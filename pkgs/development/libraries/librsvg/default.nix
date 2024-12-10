{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  gdk-pixbuf,
  installShellFiles,
  pango,
  cairo,
  libxml2,
  bzip2,
  libintl,
  ApplicationServices,
  Foundation,
  libobjc,
  rustPlatform,
  rustc,
  cargo-auditable-cargo-wrapper,
  gi-docgen,
  python3Packages,
  gnome,
  vala,
  writeScript,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  buildPackages,
  gobject-introspection,
  _experimental-update-script-combinators,
  common-updater-scripts,
  jq,
  nix,

  # for passthru.tests
  enlightenment,
  ffmpeg,
  gegl,
  gimp,
  imagemagick,
  imlib2,
  vips,
  xfce,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librsvg";
  version = "2.58.1";

  outputs =
    [
      "out"
      "dev"
    ]
    ++ lib.optionals withIntrospection [
      "devdoc"
    ];

  src = fetchurl {
    url = "mirror://gnome/sources/librsvg/${lib.versions.majorMinor finalAttrs.version}/librsvg-${finalAttrs.version}.tar.xz";
    hash = "sha256-NyhZYpCoV20wXQbsiv30c1Fv7unf8i4DI16sQz1Wgk4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    name = "librsvg-deps-${finalAttrs.version}";
    hash = "sha256-FIW92Cr83YkGTOe/xjyZGZvHYSrG70GBpHc9l0sMjLg=";
    # TODO: move this to fetchCargoTarball
    dontConfigure = true;
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs =
    [
      gdk-pixbuf
      installShellFiles
      pkg-config
      rustc
      cargo-auditable-cargo-wrapper
      python3Packages.docutils
      vala
      rustPlatform.cargoSetupHook
    ]
    ++ lib.optionals withIntrospection [
      gobject-introspection
      gi-docgen
    ];

  buildInputs =
    [
      libxml2
      bzip2
      pango
      libintl
      vala # for share/vala/Makefile.vapigen
    ]
    ++ lib.optionals stdenv.isDarwin [
      ApplicationServices
      Foundation
      libobjc
    ];

  propagatedBuildInputs = [
    glib
    gdk-pixbuf
    cairo
  ];

  configureFlags =
    [
      (lib.enableFeature withIntrospection "introspection")
      (lib.enableFeature withIntrospection "vala")

      "--enable-always-build-tests"
    ]
    ++ lib.optional stdenv.isDarwin "--disable-Bsymbolic"
    ++ lib.optional (
      stdenv.buildPlatform != stdenv.hostPlatform
    ) "RUST_TARGET=${stdenv.hostPlatform.rust.rustcTarget}";

  doCheck = false; # all tests fail on libtool-generated rsvg-convert not being able to find coreutils

  GDK_PIXBUF_QUERYLOADERS = writeScript "gdk-pixbuf-loader-loaders-wrapped" ''
    ${lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (stdenv.hostPlatform.emulator buildPackages)} ${lib.getDev gdk-pixbuf}/bin/gdk-pixbuf-query-loaders
  '';

  # librsvg only links Foundation, but it also requiers libobjc. The Framework.tbd in the 11.0 SDK
  # reexports libobjc, but the one in the 10.12 SDK does not, so link it manually.
  env = lib.optionalAttrs (stdenv.isDarwin && stdenv.isx86_64) {
    NIX_LDFLAGS = "-lobjc";
  };

  preConfigure = ''
    PKG_CONFIG_VAPIGEN_VAPIGEN="$(type -p vapigen)"
    export PKG_CONFIG_VAPIGEN_VAPIGEN
  '';

  # It wants to add loaders and update the loaders.cache in gdk-pixbuf
  # Patching the Makefiles to it creates rsvg specific loaders and the
  # relevant loader.cache here.
  # The loaders.cache can be used by setting GDK_PIXBUF_MODULE_FILE to
  # point to this file in a wrapper.
  postConfigure =
    ''
      GDK_PIXBUF=$out/lib/gdk-pixbuf-2.0/2.10.0
      mkdir -p $GDK_PIXBUF/loaders
      sed -i gdk-pixbuf-loader/Makefile \
        -e "s#gdk_pixbuf_moduledir = .*#gdk_pixbuf_moduledir = $GDK_PIXBUF/loaders#" \
        -e "s#gdk_pixbuf_cache_file = .*#gdk_pixbuf_cache_file = $GDK_PIXBUF/loaders.cache#" \
        -e "s#\$(GDK_PIXBUF_QUERYLOADERS)#GDK_PIXBUF_MODULEDIR=$GDK_PIXBUF/loaders \$(GDK_PIXBUF_QUERYLOADERS)#"

      # Fix thumbnailer path
      sed -e "s#@bindir@\(/gdk-pixbuf-thumbnailer\)#${gdk-pixbuf}/bin\1#g" \
          -i gdk-pixbuf-loader/librsvg.thumbnailer.in

      # 'error: linker `cc` not found' when cross-compiling
      export RUSTFLAGS="-Clinker=$CC"
    ''
    +
      lib.optionalString
        (
          (stdenv.buildPlatform != stdenv.hostPlatform)
          && (stdenv.hostPlatform.emulatorAvailable buildPackages)
        )
        ''
          # the replacement is the native conditional
          substituteInPlace gdk-pixbuf-loader/Makefile \
            --replace 'RUN_QUERY_LOADER_TEST = false' 'RUN_QUERY_LOADER_TEST = test -z "$(DESTDIR)"' \
        '';

  # Not generated when cross compiling.
  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      # Merge gdkpixbuf and librsvg loaders
      cat ${lib.getLib gdk-pixbuf}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache $GDK_PIXBUF/loaders.cache > $GDK_PIXBUF/loaders.cache.tmp
      mv $GDK_PIXBUF/loaders.cache.tmp $GDK_PIXBUF/loaders.cache

      installShellCompletion --cmd rsvg-convert \
        --bash <(${emulator} $out/bin/rsvg-convert --completion bash) \
        --fish <(${emulator} $out/bin/rsvg-convert --completion fish) \
        --zsh <(${emulator} $out/bin/rsvg-convert --completion zsh)
    '';

  postFixup = lib.optionalString withIntrospection ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  passthru = {
    updateScript =
      let
        updateSource = gnome.updateScript {
          packageName = "librsvg";
        };

        updateLockfile = {
          command = [
            "sh"
            "-c"
            ''
              PATH=${
                lib.makeBinPath [
                  common-updater-scripts
                  jq
                  nix
                ]
              }
              # update-source-version does not allow updating to the same version so we need to clear it temporarily.
              # Get the current version so that we can restore it later.
              latestVersion=$(nix-instantiate --eval -A librsvg.version | jq --raw-output)
              # Clear the version. Provide hash so that we do not need to do pointless TOFU.
              # Needs to be a fake SRI hash that is non-zero, since u-s-v uses zero as a placeholder.
              # Also cannot be here verbatim or u-s-v would be confused what to replace.
              update-source-version librsvg 0 "sha256-${
                lib.fixedWidthString 44 "B" "="
              }" --source-key=cargoDeps > /dev/null
              update-source-version librsvg "$latestVersion" --source-key=cargoDeps > /dev/null
            ''
          ];
          # Experimental feature: do not copy!
          supportedFeatures = [ "silent" ];
        };
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updateLockfile
      ];
    tests = {
      inherit
        gegl
        gimp
        imagemagick
        imlib2
        vips
        ;
      inherit (enlightenment) efl;
      inherit (xfce) xfwm4;
      ffmpeg = ffmpeg.override { withSvg = true; };
    };
  };

  meta = with lib; {
    description = "A small library to render SVG images to Cairo surfaces";
    homepage = "https://gitlab.gnome.org/GNOME/librsvg";
    license = licenses.lgpl2Plus;
    maintainers = teams.gnome.members;
    mainProgram = "rsvg-convert";
    platforms = platforms.unix;
  };
})
