/*
  ** To customize the enabled beets plugins, use the pluginOverrides input to the
  ** derivation.
  ** Examples:
  **
  ** Disabling a builtin plugin:
  ** python3.pkgs.beets.override {
  **   pluginOverrides = {
  **     beatport.enable = false;
  **   };
  ** }
  **
  ** Enabling an external plugin:
  ** python3.pkgs.beets.override {
  **   pluginOverrides = {
  **     alternatives = {
  **       enable = true;
  **       propagatedBuildInputs = [ beets-alternatives ];
  **     };
  **   };
  ** }
  **
  ** For an example adding a builtin plugin, see
  ** passthru.tests.with-new-builtin-plugin below
*/
{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  confuse,
  gst-python,
  jellyfish,
  mediafile,
  munkres,
  musicbrainzngs,
  packaging,
  platformdirs,
  pyyaml,
  unidecode,
  reflink,
  requests-ratelimiter,
  typing-extensions,
  lap,

  # native
  gobject-introspection,

  # buildInputs
  gst_all_1,

  # plugin deps
  aacgain,
  beautifulsoup4,
  chromaprint,
  dbus-python,
  discogs-client,
  ffmpeg,
  flac,
  flask,
  flask-cors,
  imagemagick,
  keyfinder-cli,
  langdetect,
  librosa,
  mp3gain,
  mp3val,
  python-mpd2,
  pyacoustid,
  pylast,
  pyxdg,
  requests,
  requests-oauthlib,
  resampy,
  titlecase,
  soco,

  # configurations
  extraPatches ? [ ],
  pluginOverrides ? { },
  disableAllPlugins ? false,
  extraDisabledTests ? [ ],
  extraNativeBuildInputs ? [ ],

  # tests
  doCheck ? true,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-factoryboy,
  pytest-flask,
  mock,
  rarfile,
  responses,
  requests-mock,
  pillow,
  tomli,
  writableTmpDirAsHomeHook,

  # preCheck
  bashInteractive,
  diffPlugins,
  runtimeShell,
  writeScript,

  # passthru.tests
  runCommand,
  beets,
}:

buildPythonPackage (finalAttrs: {
  pname = "beets";
  version = "2.13.1";
  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "beets";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f25Uv7PRKBFUWah6pvEwwTFjxXKQfmAP2fyTNFJyWB0=";
  };
  pyproject = true;

  patches = extraPatches;

  build-system = [
    hatchling
  ];

  dependencies = [
    confuse
    gst-python
    jellyfish
    mediafile
    munkres
    musicbrainzngs
    packaging
    platformdirs
    pyyaml
    unidecode
    # Can be built without it, but is useful on btrfs systems, and doesn't
    # add too much to the closure. See:
    # https://github.com/NixOS/nixpkgs/issues/437308
    reflink
    requests-ratelimiter
    typing-extensions
    lap
  ]
  ++ (lib.concatMap (p: p.propagatedBuildInputs) (
    lib.attrValues finalAttrs.finalPackage.passthru.plugins.enabled
  ));

  nativeBuildInputs = [
    gobject-introspection
  ]
  ++ extraNativeBuildInputs;

  buildInputs = with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
  ];

  outputs = [
    "out"
  ];

  postInstall = ''
    mkdir -p $out/share/zsh/site-functions
    cp extra/_beet $out/share/zsh/site-functions/
  '';

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\""
    "--set GST_PLUGIN_SYSTEM_PATH_1_0 \"$GST_PLUGIN_SYSTEM_PATH_1_0\""
    "--prefix PATH : ${lib.makeBinPath finalAttrs.finalPackage.passthru.plugins.wrapperBins}"
  ];

  nativeCheckInputs = [
    ffmpeg
    pytestCheckHook
    pytest-cov-stub
    pytest-factoryboy
    pytest-flask
    mock
    rarfile
    responses
    requests-mock
    pillow
    tomli
    writableTmpDirAsHomeHook
  ]
  ++ finalAttrs.finalPackage.passthru.plugins.wrapperBins;

  inherit doCheck;

  __darwinAllowLocalNetworking = true;

  disabledTestPaths =
    finalAttrs.finalPackage.passthru.plugins.disabledTestPaths
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Flaky: several tests fail randomly with:
      # if not self._poll(timeout):
      #   raise Empty
      #   _queue.Empty
      "test/plugins/test_bpd.py"
    ];
  disabledTests = extraDisabledTests ++ [
    # touches network
    "test_merge_duplicate_album"
    # The existence of the dependency reflink (see comment above), causes this
    # test to be run, and it fails in the sandbox.
    "test_successful_reflink"
  ];

  # Perform extra "sanity checks", before running pytest tests.
  preCheck = ''
    # Check for undefined plugins
    find beetsplug -mindepth 1 \
      \! -path 'beetsplug/__init__.py' -a \
      \( -name '*.py' -o -path 'beetsplug/*/__init__.py' \) -print \
      | sed -n -re 's|^beetsplug/([^/.]+).*|\1|p' \
      | sort -u > plugins_available
    ${diffPlugins (lib.attrNames finalAttrs.finalPackage.passthru.plugins.builtins) "plugins_available"}

    export BEETS_TEST_SHELL="${lib.getExe bashInteractive} --norc"

    env EDITOR="${writeScript "beetconfig.sh" ''
      #!${runtimeShell}
      cat > "$1" <<CFG
      plugins: ${lib.concatStringsSep " " (lib.attrNames finalAttrs.finalPackage.passthru.plugins.enabled)}
      CFG
    ''}" "$out/bin/beet" config -e
    env EDITOR=true "$out/bin/beet" config -e
  '';

  passthru = {
    plugins = {
      builtins = {
        absubmit = {
          deprecated = true;
          testPaths = [ ];
        };
        advancedrewrite = {
          testPaths = [ ];
        };
        acousticbrainz = {
          deprecated = true;
          propagatedBuildInputs = [ requests ];
        };
        albumtypes = { };
        aura = {
          propagatedBuildInputs = [
            flask
            flask-cors
            pillow
          ];
        };
        autobpm = {
          propagatedBuildInputs = [
            librosa
            # An optional dependency of librosa, needed for beets' autobpm
            resampy
          ];
        };
        badfiles = {
          testPaths = [ ];
          wrapperBins = [
            mp3val
            flac
          ];
        };
        bareasc = { };
        beatport.propagatedBuildInputs = [ requests-oauthlib ];
        bench.testPaths = [ ];
        bpd = { };
        bpm.testPaths = [ ];
        bpsync = {
          # plugin retired: https://github.com/beetbox/beets/issues/3862.
          deprecated = true;
          testPaths = [ ];
        };
        bucket = { };
        chroma = {
          propagatedBuildInputs = [ pyacoustid ];
          wrapperBins = [
            chromaprint
          ];
        };
        convert.wrapperBins = [ ffmpeg ];
        deezer = {
          propagatedBuildInputs = [ requests ];
          testPaths = [ ];
        };
        discogs = {
          propagatedBuildInputs = [
            discogs-client
            requests
          ];
          singlePluginTest.config = {
            user_token = "test";
          };
        };
        duplicates.testPaths = [ ];
        edit = { };
        embedart = {
          propagatedBuildInputs = [ pillow ];
          wrapperBins = [ imagemagick ];
        };
        embyupdate.propagatedBuildInputs = [ requests ];
        export = { };
        fetchart = {
          propagatedBuildInputs = [
            beautifulsoup4
            langdetect
            pillow
            requests
          ];
          wrapperBins = [ imagemagick ];
        };
        filefilter = { };
        fish.testPaths = [ ];
        freedesktop.testPaths = [ ];
        fromfilename.testPaths = [ ];
        ftintitle = { };
        fuzzy.testPaths = [ ];
        hook = { };
        ihate = { };
        importadded = { };
        importfeeds = { };
        importsource = { };
        info = { };
        inline.testPaths = [ ];
        ipfs = { };
        keyfinder.wrapperBins = [ keyfinder-cli ];
        kodiupdate = {
          propagatedBuildInputs = [ requests ];
          testPaths = [ ];
        };
        lastgenre.propagatedBuildInputs = [ pylast ];
        lastimport = {
          propagatedBuildInputs = [ pylast ];
          testPaths = [ ];
        };
        limit = { };
        listenbrainz.singlePluginTest.config = {
          token = "test";
          username = "test";
        };
        loadext = {
          propagatedBuildInputs = [ requests ];
          testPaths = [ ];
        };
        lyrics.propagatedBuildInputs = [
          beautifulsoup4
          langdetect
          requests
        ];
        mbcollection.testPaths = [ ];
        mbsubmit = { };
        mbsync = { };
        mbpseudo = { };
        metasync = {
          propagatedBuildInputs = [ dbus-python ];
          testPaths = [ ];
        };
        missing.testPaths = [ ];
        mpdstats.propagatedBuildInputs = [ python-mpd2 ];
        mpdupdate = {
          propagatedBuildInputs = [ python-mpd2 ];
          testPaths = [ ];
        };
        musicbrainz = { };
        parentwork = { };
        permissions = { };
        play = { };
        playlist.propagatedBuildInputs = [ requests ];
        plexupdate = { };
        random = { };
        replace = { };
        replaygain = {
          singlePluginTest.config.backend = "gstreamer";
          wrapperBins = [
            aacgain
            ffmpeg
            mp3gain
          ];
        };
        rewrite.testPaths = [ ];
        scrub.testPaths = [ ];
        smartplaylist = { };
        sonosupdate = {
          propagatedBuildInputs = [ soco ];
          testPaths = [ ];
        };
        spotify.singlePluginTest.setup = ''
          mkdir -p $HOME/.config/beets
          echo '{"access_token":"test"}' > $HOME/.config/beets/spotify_token.json
        '';
        subsonicplaylist = {
          propagatedBuildInputs = [ requests ];
          testPaths = [ ];
        };
        subsonicupdate.propagatedBuildInputs = [ requests ];
        substitute = {
          testPaths = [ ];
        };
        tidal.propagatedBuildInputs = [ requests-oauthlib ];
        the = { };
        titlecase.propagatedBuildInputs = [ titlecase ];
        thumbnails = {
          propagatedBuildInputs = [
            pillow
            pyxdg
          ];
          wrapperBins = [ imagemagick ];
        };
        types.testPaths = [ "test/plugins/test_types_plugin.py" ];
        unimported.testPaths = [ ];
        web.propagatedBuildInputs = [
          flask
          flask-cors
        ];
        zero = { };
        _typing = {
          testPaths = [ ];
        };
        _utils = {
          testPaths = [ ];
        };
      };
      base = lib.mapAttrs (
        _: a: { builtin = true; } // a
      ) finalAttrs.finalPackage.passthru.plugins.builtins;
      overrides = lib.mapAttrs (
        plugName:
        lib.throwIf (finalAttrs.finalPackage.passthru.plugins.builtins.${plugName}.deprecated or false)
          "beets evaluation error: Plugin ${plugName} was enabled in pluginOverrides, but it has been removed. Remove the override to fix evaluation."
      ) pluginOverrides;
      all = lib.pipe finalAttrs.finalPackage.passthru.plugins.base [
        (base: lib.recursiveUpdate base finalAttrs.finalPackage.passthru.plugins.overrides)
        (lib.mapAttrs (
          n: a:
          lib.recursiveUpdate {
            name = n;
            enable = !disableAllPlugins;
            builtin = false;
            propagatedBuildInputs = [ ];
            singlePluginTest = {
              config = { };
              setup = "";
            };
            testPaths = [ "test/plugins/test_${n}.py" ];
            wrapperBins = [ ];
          } a
        ))
      ];
      enabled = lib.filterAttrs (_: p: p.enable) finalAttrs.finalPackage.passthru.plugins.all;
      disabled = lib.filterAttrs (_: p: !p.enable) finalAttrs.finalPackage.passthru.plugins.all;
      disabledTestPaths = lib.flatten (
        lib.attrValues (lib.mapAttrs (_: v: v.testPaths) finalAttrs.finalPackage.passthru.plugins.disabled)
      );
      wrapperBins = lib.concatMap (p: p.wrapperBins) (
        lib.attrValues finalAttrs.finalPackage.passthru.plugins.enabled
      );
    };
    tests = {
      with-new-builtin-plugin = finalAttrs.finalPackage.overrideAttrs (
        newAttrs: oldAttrs: {
          postPatch = (oldAttrs.postPatch or "") + ''
            mkdir -p beetsplug/my_special_plugin
            touch beetsplug/my_special_plugin/__init__.py
          '';
          passthru = lib.recursiveUpdate oldAttrs.passthru {
            plugins.builtins.my_special_plugin = { };
          };
        }
      );
      # Test that disabling
      with-mpd-plugins-disabled = beets.override {
        pluginOverrides = {
          # These two plugins require mpd2 Python dependency. If they are
          # disabled, this dependency shouldn't be pulled, and the `runCommand`
          # test below should fail with a `ModuleNotFoundError`
          mpdstats.enable = false;
          mpdupdate.enable = false;
        };
      };
      mpd-plugins-really-disabled = runCommand "beets-mpd-plugins-disabled-test" { } ''
        set -euo pipefail
        export HOME=$(mktemp -d)
        mkdir $out

        cat << EOF > $out/config.yaml
        plugins:
          - mpdstats
        EOF
        ${finalAttrs.finalPackage.passthru.tests.with-mpd-plugins-disabled}/bin/beet \
          -c $out/config.yaml \
          --help 2> $out/help-stderr || true
        ${finalAttrs.finalPackage.passthru.tests.with-mpd-plugins-disabled}/bin/beet \
          -c $out/config.yaml \
          mpdstats --help 2> $out/mpdstats-help-stderr || true
      '';
    }
    # Build and start beets once for each supported built-in plugin. Keeping the
    # plugins isolated makes missing optional dependencies visible.
    // lib.pipe finalAttrs.finalPackage.passthru.plugins.all [
      # Deprecated plugins are not useful regression targets.
      (lib.filterAttrs (_: pluginAttrs: !(pluginAttrs.deprecated or false)))
      (lib.concatMapAttrs (
        pluginName: pluginAttrs:
        let
          testConfig = {
            plugins = [ pluginName ];
          }
          # Some plugins do not accept an empty attribute set as config.
          // lib.optionalAttrs (pluginAttrs.singlePluginTest.config != { }) {
            ${pluginName} = pluginAttrs.singlePluginTest.config;
          };
          beetsWithSinglePlugin = beets.override {
            disableAllPlugins = true;
            pluginOverrides = {
              ${pluginName}.enable = true;
            };
            # The runCommand below is the relevant check; avoid running
            # the full upstream test suite once per plugin. NOTE that
            # testing whether any plugin's `testPaths` is incorrect, is
            # done for all plugins via the `beets-minimal` derivation.
            doCheck = false;
          };
        in
        {
          "with-single-plugin-${pluginName}" = beetsWithSinglePlugin;
          "single-plugin-${pluginName}" = runCommand "beets-single-plugin-${pluginName}-test" { } ''
            set -euo pipefail
            export HOME=$(mktemp -d)
            ${pluginAttrs.singlePluginTest.setup}
            mkdir $out

            cat <<'EOF' > $out/config.yaml
            ${lib.generators.toYAML { } testConfig}
            EOF

            status=0
            ${lib.getExe beetsWithSinglePlugin} \
              -c "$out/config.yaml" \
              --help > "$out/stdout" 2> "$out/stderr" || status=$?

            # beet exits successfully when a plugin fails to load, so its
            # stderr must also be checked for the diagnostic.
            if (( status != 0 )) || grep -Fq "error loading plugin" "$out/stderr"; then
              {
                printf '%s\n' '----- stdout -----'
                cat "$out/stdout"
                printf '%s\n' '----- stderr -----'
                cat "$out/stderr"
              } >&2
              exit 1
            fi
          '';
        }
      ))
    ];
  };

  meta = {
    description = "Music tagger and library organizer";
    homepage = "https://beets.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      astratagem
      doronbehar
      lovesegfault
      pjones
      staticdev
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "beet";
  };
})
