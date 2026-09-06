{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  darwin,
  nodejs_22,
  perl,
  python3,
  zip,
  unzip,
  xz,
  gawk,
  rsync,
  pkg-config,
  pango,
  giflib,
  firefox-esr-140-unwrapped,
  makeDesktopItem,
  copyDesktopItems,
  libGL,
  pciutils,
  speechd-minimal,
  wrapGAppsHook3,
  nix-update-script,
  xvfb-run,
  makeBinaryWrapper,
  doCheck ? false,
  zotero,
}:
let
  # note-editor needs nodejs 22. Any newer version fails to build zotero's fork of @benrbray/prosemirror-math during npm install.
  nodejs = nodejs_22;

  pname = "zotero";
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-lNeujToTGzOTG7aKycoZfnyZawM9EQFWSdRJ4/KEPqQ=";
  };

  pdf-js = buildNpmPackage {
    pname = "zotero-pdf-js";
    inherit version nodejs;
    src = "${src}/reader/pdfjs/pdf.js";
    npmDepsHash = "sha256-xq0RhCruM22mFC3zkHpn4hX8YdO32Sn42fbSC0cQXFw=";
    buildPhase = ''
      runHook preBuild

      npm exec gulp generic
      npm exec gulp generic-legacy
      npm exec gulp minified-legacy

      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r . $out

      runHook postInstall
    '';
  };

  epub-js = buildNpmPackage {
    pname = "zotero-epub-js";
    inherit version nodejs;
    src = "${src}/reader/epubjs/epub.js";
    npmDepsHash = "sha256-6XY6uczPOpMpRHDQbkQRHKBDDRQ/MXIVepGBx1V+h5Q=";
    buildPhase = ''
      runHook preBuild

      npm run compile
      npm run build

      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r . $out

      runHook postInstall
    '';
  };

  pdf-reader = buildNpmPackage {
    pname = "zotero-pdf-reader";
    inherit version nodejs;
    src = "${src}/reader";
    npmDepsHash = "sha256-/Szv0BWy9zHLrusRxo8XRtfyFmq/rS4GG1iO7NkV2BQ=";
    patches = [
      ./pdf-reader-locales.patch
      ./pdf-reader-build-fix.patch
    ];
    postPatch = ''
      rm -rf pdfjs/pdf.js
      cp -r ${pdf-js} pdfjs/pdf.js
      chmod -R u+w pdfjs/pdf.js

      rm -rf epubjs/epub.js
      cp -r ${epub-js} epubjs/epub.js
      chmod -R u+w epubjs/epub.js

      mkdir -p locales/en-US/
      cp -r ${src}/chrome/locale/en-US/zotero/* locales/en-US/
    '';
    npmBuildScript = "build:zotero";
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r . $out

      runHook postInstall
    '';
  };

  document-worker = buildNpmPackage {
    pname = "zotero-document-worker";
    inherit version nodejs;
    src = "${src}/document-worker";
    npmDepsHash = "sha256-dUGZ0RsmW+cAXPi78W9eX7kQnTiCVc8K9lPPtw8Cif0=";
    nativeBuildInputs = [
      rsync
      pkg-config
    ];
    buildInputs = [
      pango
      giflib
    ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r . $out

      runHook postInstall
    '';
  };

  note-editor = buildNpmPackage {
    pname = "zotero-note-editor";
    inherit version nodejs;
    src = "${src}/note-editor";
    npmDepsHash = "sha256-3KSSm8oCNOIDN/ZHhDbx7+cF20qtjtZwpnCOOWe3WQc=";
    makeCacheWritable = true;
    patches = [ ./pdf-reader-locales.patch ];
    postPatch = ''
      mkdir -p locales/en-US/
      cp -r ${src}/chrome/locale/en-US/zotero/* locales/en-US/
    '';
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r . $out

      runHook postInstall
    '';
  };

in
buildNpmPackage (finalAttrs: {
  inherit
    pname
    version
    src
    nodejs
    ;

  npmDepsHash = "sha256-dtbA1V38u26gqWoN+kW/tnccl6HFX7p8fPAneq+mw6U=";

  nativeBuildInputs = [
    perl
    python3
    zip
    unzip
    xz
    gawk
    rsync
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    darwin.autoSignDarwinBinariesHook
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    wrapGAppsHook3
  ];

  patches = [
    ./avoid-git.patch
    ./js-build-fixes.patch
    ./avoid-xulrunner-fetch.patch
    ./build-fixes.patch
  ];

  postPatch = ''
    rm -rf reader
    cp -r ${pdf-reader} reader
    chmod -R u+w reader

    rm -rf document-worker
    cp -r ${document-worker} document-worker
    chmod -R u+w document-worker

    rm -rf note-editor
    cp -r ${note-editor} note-editor
    chmod -R u+w note-editor

    patchShebangs --build app/ test/

    # Skip some flaky/failing tests
    rm test/tests/retractionsTest.js test/tests/debugTest.js
    for test in \
      "should use BrowserRequest for 403 when enforcing file type" \
      "should use BrowserRequest for a JS redirect page" \
      "should throw error on broken symlink" \
      "should mark every selected collection as current for a multiple-collection selection" \
    ; do
      sed -i -E "s|it(\([\"']$test.*[\"'])|it.skip\1|" test/tests/*.js
    done
  '';

  buildPhase =
    let
      zoteroArch =
        platform:
        if platform.isAarch64 then
          "arm64"
        else if platform.isx86_64 then
          "x64"
        else if platform.isx86_32 then
          "i686"
        else
          platform.parsed.cpu.name;
    in
    ''
      runHook preBuild

      npm run build

      # Place firefox files at the right place.
      # The correct firefox version can be found in zotero/app/config.sh at `GECKO_VERSION_LINUX`.
      mkdir -p app/xulrunner/
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp -r "${firefox-esr-140-unwrapped}/Applications/Firefox ESR.app" app/xulrunner/Firefox.app
    ''
    + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
      cp -r "${firefox-esr-140-unwrapped}/lib/firefox" "app/xulrunner/firefox-${stdenv.hostPlatform.parsed.kernel.name}-${
        lib.replaceString "aarch64" "arm64" stdenv.hostPlatform.parsed.cpu.name
      }"
    ''
    + ''
      chmod -R u+w app/xulrunner/

      build_dir=$(mktemp -d)
      ./app/scripts/prepare_build -s ./build -o "$build_dir" -c release
      ./app/build.sh -d "$build_dir" -c release -s \
        ${if stdenv.hostPlatform.isDarwin then "-p m" else "-p l -a ${zoteroArch stdenv.hostPlatform}"}

      runHook postBuild
    '';

  inherit doCheck;
  # Build with test support if `doCheck` is enabled.
  env.ZOTERO_TEST = doCheck;

  nativeCheckInputs = [
    xvfb-run
  ];

  checkPhase = ''
    runHook preCheck

    CI=true xvfb-run test/runtests.sh

    runHook postCheck
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "zotero";
      exec = "zotero -url %U";
      icon = "zotero";
      comment = finalAttrs.meta.description;
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
    })
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Copy package contents
    mkdir -p $out/Applications
    cp -r app/staging/Zotero.app $out/Applications/
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    # Copy package contents
    mkdir -p $out/lib/
    cp -r app/staging/*/. $out/lib/

    # Add binary to bin/
    mkdir -p $out/bin/
    ln -s ../lib/zotero $out/bin/zotero

    # Install icons
    for size in 32 64 128; do
      install -Dm444 "app/linux/icons/icon''${size}.png" "$out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png"
    done
    install -Dm444 "app/linux/icons/symbolic.svg" "$out/share/icons/hicolor/scalable/apps/zotero-symbolic.svg"
  ''
  + ''
    runHook postInstall
  '';

  preFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    gappsWrapperArgs+=(--suffix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libGL
        pciutils
        speechd-minimal
      ]
    })
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    makeWrapper $out/Applications/Zotero.app/Contents/MacOS/zotero $out/bin/zotero
  '';

  passthru = {
    tests.build-with-checks = zotero.override {
      doCheck = true;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    changelog = "https://www.zotero.org/support/changelog";
    mainProgram = "zotero";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      mynacol
    ];
  };
})
