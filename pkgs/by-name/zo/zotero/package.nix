{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  buildNpmPackage,

  which,
  git,
  nodejs_20,
  nodejs_24,
  perl,
  python3,
  curl,
  wget,
  zip,
  unzip,
  xz,
  gawk,
  rsync,
  buildMozillaMach,
  python311,
  rustPlatform,
  cmake,
  python3Packages,

  wrapGAppsHook3,
  makeDesktopItem,
  atk,
  cairo,
  dbus-glib,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libva,
  xorg,
  libgbm,
  pango,
  pciutils,
  alsaSupport ? true,
  alsa-lib,
  jackSupport ? true,
  libjack2,
  pulseSupport ? true,
  libpulseaudio,
  sndioSupport ? true,
  sndio,
}:
let
  nodejs = nodejs_20;

  pname = "zotero";
  version = "7.0.30";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    tag = version;
    hash = "sha256-/DDtKtRM5ddNekItHI6wAY1YoJmqSk77Lfubo/I6KxU=";
    fetchSubmodules = true;
  };

  pdf-js = buildNpmPackage {
    pname = "zotero-pdf-js";
    inherit version;
    nodejs = nodejs_24;
    src = "${src}/pdf-worker/pdf.js";
    npmDepsHash = "sha256-/me+tZdxChpPw0bsvD1fWqBgZezsN8EhL/pC7wTDuFE=";
    prePatch = ''
      # Drop unmaintained @jazzer fuzzer, it leads to `prebuild: command not found` and is not needed for builds.
      # TODO: use https://gitlab.alpinelinux.org/alpine/aports/-/raw/master/community/zotero/zotero_drop-jazzer.patch?inline=false instead
      substituteInPlace package.json \
        --replace-fail '"@jazzer.js/core": "^2.1.0",' ""
    '';
    buildPhase = ''
      npm exec gulp lib-legacy
      npm exec gulp generic-legacy
      npm exec gulp minified-legacy
    '';
    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };

  epub-js = buildNpmPackage {
    pname = "zotero-epub-js";
    inherit version nodejs;
    src = "${src}/reader/epubjs/epub.js";
    npmDepsHash = "sha256-JYOEDX6SxB4Epwq5PZ5Y+EJO6UGKsOBIm2XIAqOwDO8=";
    npmBuildScript = "prepare";
    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };

  pdf-reader = buildNpmPackage {
    pname = "zotero-pdf-reader";
    inherit version;
    nodejs = nodejs_24;
    src = "${src}/reader";
    npmDepsHash = "sha256-kD3xA3N0gETKnB1nNl0c7Zkh+3zQEcQtsY7cZBdh8KQ=";
    postPatch = ''
      rm -rf pdfjs/pdf.js
      cp -r ${pdf-js} pdfjs/pdf.js

      rm -rf epubjs/epub.js
      cp -r ${epub-js} epubjs/epub.js
      chmod -R u+w epubjs/epub.js

      substituteInPlace epubjs/epub.js/package.json \
        --replace-fail '"prepare":' '"prepare_old":'
    '';
    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };

  pdf-worker = buildNpmPackage {
    pname = "zotero-pdf-worker";
    inherit version nodejs;
    src = "${src}/pdf-worker";
    npmDepsHash = "sha256-TGuN1fZOClzm6xD2rmn5BAemN4mbyOVaLbSRyMeDIm8=";
    nativeBuildInputs = [
      rsync
    ];
    postPatch = ''
      rm -rf pdf.js
      cp -r ${pdf-js} pdf.js
    '';
    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };

  note-editor = buildNpmPackage {
    pname = "zotero-note-editor";
    inherit version nodejs;
    src = "${src}/note-editor";
    npmDepsHash = "sha256-9DJNlbyRgiipjrpiXGVFOl5zALJOwLCyw8TRkfwm5Ns=";
    makeCacheWritable = true;
    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };

  rust-cbindgen-026 = rustPlatform.buildRustPackage rec {
    pname = "rust-cbindgen";
    version = "0.26.0";

    src = fetchFromGitHub {
      owner = "mozilla";
      repo = "cbindgen";
      rev = "v${version}";
      hash = "sha256-gyNZAuxpeOjuC+Rh9jAyHSBQRRYUlYoIrBKuCFg3Hao=";
    };

    cargoHash = "sha256-Mn6TigV/+zqG5CsjHMDYAN54P6qw4G03g7JuUM7GbPw=";

    #buildInputs = lib.optional stdenv.isDarwin Security;

    nativeCheckInputs = [
      cmake
      python3Packages.cython
    ];

    checkFlags = [
      # Disable tests that require rust unstable features
      # https://github.com/eqrion/cbindgen/issues/338
      "--skip test_expand"
      "--skip test_bitfield"
      "--skip lib_default_uses_debug_build"
      "--skip lib_explicit_debug_build"
      "--skip lib_explicit_release_build"
      "--skip bin_explicit_release_build"
      "--skip bin_default_uses_debug_build"
      "--skip bin_explicit_debug_build"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # WORKAROUND: test_body fails when using clang
      # https://github.com/eqrion/cbindgen/issues/628
      "--skip test_body"
    ];

    meta = {
      license = lib.licenses.mpl20;
    };
  };

  firefox-115 =
    (buildMozillaMach rec {
      pname = "firefox-esr-115";
      version = "115.31.0esr";
      applicationName = "Mozilla Firefox ESR";
      src = fetchurl {
        url = "mirror://mozilla/firefox/releases/${version}/source/firefox-${version}.source.tar.xz";
        sha512 = "5a56764be6f3d1a4c9f2ee289ec2f220670ad3b99e9ab83a63e24f5fcd023611af7c9bdb81f9baef0d5fe003576d56cee01cf563f6686905363d4c925e4022e2";
      };

      meta = {
        platforms = lib.platforms.unix;
        badPlatforms = lib.platforms.darwin;
        broken = stdenv.buildPlatform.is32bit;
        # since Firefox 60, build on 32-bit platforms fails with "out of memory".
        # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
        license = lib.licenses.mpl20;
      };
    }).override
      {
        python3 = python311;
        elfhackSupport = false;
        rust-cbindgen = rust-cbindgen-026;
      };

in
buildNpmPackage rec {
  inherit
    pname
    version
    src
    nodejs
    ;

  npmDepsHash = "sha256-qWeUeiwM6sCNovSoaEP3b42VTnCFSWLK9y8qPnWcSTE=";

  nativeBuildInputs = [
    #which
    git
    nodejs
    perl
    python3
    curl
    wget
    zip
    unzip
    xz
    gawk
    rsync
  ];

  patches = [
    ./git-revs.patch
    ./avoid-xulrunner-fetch.patch
  ];

  postPatch = ''
    substituteInPlace app/scripts/dir_build \
      --replace-quiet 'hash=`git -C "$ROOT_DIR" rev-parse --short HEAD`' 'hash="e9281c51fd464246b60eee4b3ba999eb4f67d36f"'

    rm -rf reader
    cp -r ${pdf-reader} reader

    rm -rf pdf-worker
    cp -r ${pdf-worker} pdf-worker

    rm -rf note-editor
    cp -r ${note-editor} note-editor

    patchShebangs --build app/
  '';

  #preBuild = "app/scripts/check_requirements";

  buildPhase = ''
    runHook preBuild

    npm run build

    # Place firefox files at the right place
    mkdir -p app/xulrunner
    cp -r ${firefox-115}/lib/firefox/ app/xulrunner/
    chmod -R u+w app/xulrunner/

    app/scripts/dir_build

    runHook postBuild
  '';

  desktopItem = makeDesktopItem {
    name = "zotero";
    exec = "zotero -url %U";
    icon = "zotero";
    comment = meta.description;
    desktopName = "Zotero";
    genericName = "Reference Management";
    categories = [
      "Office"
      "Database"
    ];
    startupNotify = true;
    mimeTypes = [
      "x-scheme-handler/zotero"
      "text/plain"
    ];
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/
    cp -r app/staging/*/. $out/lib/

    runHook postInstall
  '';

  /*
    installPhase = ''
      runHook preInstall

      # Copy package contents to the output directory
      mkdir -p "$prefix/usr/lib/zotero-bin-${version}"
      cp -r * "$prefix/usr/lib/zotero-bin-${version}"
      mkdir -p "$out/bin"
      ln -s "$prefix/usr/lib/zotero-bin-${version}/zotero" "$out/bin/"

      # Install desktop file and icons
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications/
      for size in 32 64 128; do
        install -Dm444 icons/icon''${size}.png \
          $out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
      done
      install -Dm444 icons/symbolic.svg \
        $out/share/icons/hicolor/symbolic/apps/zotero-symbolic.svg

      runHook postInstall
    '';

    postFixup = ''
      for executable in \
        zotero-bin plugin-container updater vaapitest \
        minidump-analyzer glxtest
      do
        if [ -e "$out/usr/lib/zotero-bin-${version}/$executable" ]; then
          patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            "$out/usr/lib/zotero-bin-${version}/$executable"
        fi
      done
      find . -executable -type f -exec \
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/zotero-bin-${version}/{}" \;
    '';
  */

  meta = {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    mainProgram = "zotero";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      atila
      justanotherariel
    ];
  };
}
