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
*/
{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  beets,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  confuse,
  gst-python,
  jellyfish,
  mediafile,
  munkres,
  musicbrainzngs,
  platformdirs,
  pyyaml,
  unidecode,
  reflink,
  typing-extensions,
  lap,

  # native
  gobject-introspection,
  sphinxHook,
  sphinx-design,
  sphinx-copybutton,
  pydata-sphinx-theme,

  # buildInputs
  gst_all_1,

  # plugin deps
  aacgain,
  beautifulsoup4,
  chromaprint,
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
  mpd2,
  pyacoustid,
  pylast,
  pyxdg,
  requests,
  requests-oauthlib,
  resampy,
  soco,

  # configurations
  extraPatches ? [ ],
  pluginOverrides ? { },
  disableAllPlugins ? false,
  extraDisabledTests ? [ ],
  extraNativeBuildInputs ? [ ],

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  mock,
  rarfile,
  responses,
  requests-mock,
  pillow,
  writableTmpDirAsHomeHook,

  # preCheck
  bashInteractive,
  diffPlugins,
  runtimeShell,
  writeScript,

  # passthru.tests
  runCommand,
}:

buildPythonPackage rec {
  pname = "beets";
  version = "2.5.1";
  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "beets";
    tag = "v${version}";
    hash = "sha256-H3jcEHyK13+RHVlV4zp+8M3LZ0Jc2FdmAbLpekGozLA=";
  };
  pyproject = true;

  patches = [
    # Bash completion fix for Nix
    ./bash-completion-always-print.patch
  ]
  ++ extraPatches;

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    confuse
    gst-python
    jellyfish
    mediafile
    munkres
    musicbrainzngs
    platformdirs
    pyyaml
    unidecode
    # Can be built without it, but is useful on btrfs systems, and doesn't
    # add too much to the closure. See:
    # https://github.com/NixOS/nixpkgs/issues/437308
    reflink
    typing-extensions
    lap
  ]
  ++ (lib.concatMap (p: p.propagatedBuildInputs) (lib.attrValues passthru.plugins.enabled));

  nativeBuildInputs = [
    gobject-introspection
    sphinxHook
    sphinx-design
    sphinx-copybutton
    pydata-sphinx-theme
  ]
  ++ extraNativeBuildInputs;

  buildInputs = with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];
  sphinxBuilders = [
    "html"
    "man"
  ];
  # Causes an installManPage error. Not clear why this directory gets generated
  # with the manpages. The same directory is observed correctly in
  # $doc/share/doc/beets-${version}/html
  preInstallSphinx = ''
    rm -r .sphinx/man/man/_sphinx_design_static
  '';

  postInstall = ''
    mkdir -p $out/share/zsh/site-functions
    cp extra/_beet $out/share/zsh/site-functions/
  '';

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH \"$GI_TYPELIB_PATH\""
    "--set GST_PLUGIN_SYSTEM_PATH_1_0 \"$GST_PLUGIN_SYSTEM_PATH_1_0\""
    "--prefix PATH : ${lib.makeBinPath passthru.plugins.wrapperBins}"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    mock
    rarfile
    responses
    requests-mock
    pillow
    writableTmpDirAsHomeHook
  ]
  ++ passthru.plugins.wrapperBins;

  __darwinAllowLocalNetworking = true;

  disabledTestPaths =
    passthru.plugins.disabledTestPaths
    ++ [
      # touches network
      "test/plugins/test_aura.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Flaky: several tests fail randomly with:
      # if not self._poll(timeout):
      #   raise Empty
      #   _queue.Empty
      "test/plugins/test_bpd.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # fail on Hydra with `RuntimeError: image cannot be obtained without artresizer backend`
      "test/plugins/test_art.py::AlbumArtOperationConfigurationTest::test_enforce_ratio"
      "test/plugins/test_art.py::AlbumArtOperationConfigurationTest::test_enforce_ratio_with_percent_margin"
      "test/plugins/test_art.py::AlbumArtOperationConfigurationTest::test_enforce_ratio_with_px_margin"
      "test/plugins/test_art.py::AlbumArtOperationConfigurationTest::test_minwidth"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_deinterlaced"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_deinterlaced_and_resized"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_file_not_resized"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_file_resized"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_file_resized_and_scaled"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_file_resized_but_not_scaled"
      "test/plugins/test_art.py::AlbumArtPerformOperationTest::test_resize"
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
    ${diffPlugins (lib.attrNames passthru.plugins.builtins) "plugins_available"}

    export BEETS_TEST_SHELL="${lib.getExe bashInteractive} --norc"

    env EDITOR="${writeScript "beetconfig.sh" ''
      #!${runtimeShell}
      cat > "$1" <<CFG
      plugins: ${lib.concatStringsSep " " (lib.attrNames passthru.plugins.enabled)}
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
        bpd.testPaths = [ ];
        bpm.testPaths = [ ];
        bpsync.testPaths = [ ];
        bucket = { };
        chroma = {
          propagatedBuildInputs = [ pyacoustid ];
          testPaths = [ ];
          wrapperBins = [
            chromaprint
          ];
        };
        convert.wrapperBins = [ ffmpeg ];
        deezer = {
          propagatedBuildInputs = [ requests ];
          testPaths = [ ];
        };
        discogs.propagatedBuildInputs = [
          discogs-client
          requests
        ];
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
        gmusic.testPaths = [ ];
        hook = { };
        ihate = { };
        importadded = { };
        importfeeds = { };
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
        listenbrainz = {
          testPaths = [ ];
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
        metasync.testPaths = [ ];
        missing.testPaths = [ ];
        mpdstats.propagatedBuildInputs = [ mpd2 ];
        mpdupdate = {
          propagatedBuildInputs = [ mpd2 ];
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
        replaygain.wrapperBins = [
          aacgain
          ffmpeg
          mp3gain
        ];
        rewrite.testPaths = [ ];
        scrub.testPaths = [ ];
        smartplaylist = { };
        sonosupdate = {
          propagatedBuildInputs = [ soco ];
          testPaths = [ ];
        };
        spotify = { };
        subsonicplaylist = {
          propagatedBuildInputs = [ requests ];
          testPaths = [ ];
        };
        subsonicupdate.propagatedBuildInputs = [ requests ];
        substitute = {
          testPaths = [ ];
        };
        the = { };
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
      base = lib.mapAttrs (_: a: { builtin = true; } // a) passthru.plugins.builtins;
      overrides = lib.mapAttrs (
        plugName:
        lib.throwIf (passthru.plugins.builtins.${plugName}.deprecated or false)
          "beets evaluation error: Plugin ${plugName} was enabled in pluginOverrides, but it has been removed. Remove the override to fix evaluation."
      ) pluginOverrides;
      all = lib.mapAttrs (
        n: a:
        {
          name = n;
          enable = !disableAllPlugins;
          builtin = false;
          propagatedBuildInputs = [ ];
          testPaths = [ "test/plugins/test_${n}.py" ];
          wrapperBins = [ ];
        }
        // a
      ) (lib.recursiveUpdate passthru.plugins.base passthru.plugins.overrides);
      enabled = lib.filterAttrs (_: p: p.enable) passthru.plugins.all;
      disabled = lib.filterAttrs (_: p: !p.enable) passthru.plugins.all;
      disabledTestPaths = lib.flatten (
        lib.attrValues (lib.mapAttrs (_: v: v.testPaths) passthru.plugins.disabled)
      );
      wrapperBins = lib.concatMap (p: p.wrapperBins) (lib.attrValues passthru.plugins.enabled);
    };
    tests = {
      gstreamer =
        runCommand "beets-gstreamer-test"
          {
            meta.timeout = 60;
          }
          ''
            set -euo pipefail
            export HOME=$(mktemp -d)
            mkdir $out

            cat << EOF > $out/config.yaml
            replaygain:
              backend: gstreamer
            EOF

            ${beets}/bin/beet -c $out/config.yaml > /dev/null
          '';
    };
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
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "beet";
  };
}
