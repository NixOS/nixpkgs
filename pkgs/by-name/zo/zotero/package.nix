{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_22,
  perl,
  python3,
  zip,
  unzip,
  xz,
  gawk,
  rsync,
  firefox-esr-140-unwrapped,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
  xvfb-run,
  doCheck ? false,
}:
let
  # note-editor needs nodejs 22. Any newer version fails to build zotero's fork of @benrbray/prosemirror-math during npm install.
  nodejs = nodejs_22;

  pname = "zotero";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "zotero";
    repo = "zotero";
    tag = version;
    hash = "sha256-Rm93Xclspb7cp4tTxr6OegLYf+ndyGz3YCwbf+6uGKM=";
    fetchSubmodules = true;
  };

  pdf-js = buildNpmPackage {
    pname = "zotero-pdf-js";
    inherit version nodejs;
    src = "${src}/pdf-worker/pdf.js";
    npmDepsHash = "sha256-KeYAY6EWBZVd3QucDEDtI6lwtTahCEFBFf2Ebib9HKg=";
    buildPhase = ''
      runHook preBuild

      npm exec gulp lib-legacy
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
    npmDepsHash = "sha256-p8O2gIF0S7QO0AR9TPPQsWUtRnKnf58zSl3JZN0lnuc=";
    patches = [ ./pdf-reader-locales.patch ];
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
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r . $out

      runHook postInstall
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

  npmDepsHash = "sha256-IVaT/O83kCGT7MGsTSblMKfVWeNBIpA9VJIWyikJrpk=";

  nativeBuildInputs = [
    perl
    python3
    zip
    unzip
    xz
    gawk
    rsync
    copyDesktopItems
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

    rm -rf pdf-worker
    cp -r ${pdf-worker} pdf-worker
    chmod -R u+w pdf-worker

    rm -rf note-editor
    cp -r ${note-editor} note-editor
    chmod -R u+w note-editor

    patchShebangs --build app/ test/

    # Skip some flaky/failing tests
    rm test/tests/retractionsTest.js
    for test in \
      "should throw error on broken symlink" \
      "should use BrowserDownload for 403 when enforcing file type" \
      "should use BrowserDownload for a JS redirect page" \
      "should keep attachments pane status after changing selection" \
      "should render preview robustly after making dense calls to render and discard" \
      "should discard attachment pane preview after becoming invisible" \
    ; do
      sed -i "s|it(\"$test|it.skip(\"$test|" test/tests/*.js
    done
  '';

  #preBuild = "app/scripts/check_requirements";

  buildPhase = ''
    runHook preBuild

    npm run build

    # Place firefox files at the right place.
    # The correct firefox version can be found in zotero/app/config.sh at `GECKO_VERSION_LINUX`.
    mkdir -p app/xulrunner/
    if ${lib.boolToString stdenv.targetPlatform.isDarwin}; then
      cp -r '${firefox-esr-140-unwrapped}/Applications/Firefox ESR.app' app/xulrunner/Firefox.app
    else
      cp -r '${firefox-esr-140-unwrapped}/lib/firefox' app/xulrunner/firefox-${stdenv.targetPlatform.parsed.kernel.name}-${
        lib.replaceString "aarch64" "arm64" stdenv.targetPlatform.parsed.cpu.name
      }
    fi
    chmod -R u+w app/xulrunner/

    app/scripts/dir_build

    runHook postBuild
  '';

  inherit doCheck;
  # Build with test support if `doCheck` is enabled.
  env.ZOTERO_TEST = doCheck;

  nativeCheckInputs = [
    xvfb-run
  ];

  checkPhase = ''
    CI=true xvfb-run test/runtests.sh
  '';

  desktopItem = makeDesktopItem {
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
  };

  installPhase = ''
    runHook preInstall

    if ${lib.boolToString stdenv.targetPlatform.isDarwin}; then

      # Copy package contents
      mkdir -p $out/Applications
      cp -r app/staging/Zotero.app $out/Applications/

    else

      # Copy package contents
      mkdir -p $out/lib/ $out/bin/
      cp -r app/staging/*/. $out/lib/

      # Add binary to bin/
      ln -s ../lib/zotero $out/bin/zotero

      # Install icons
      for size in 32 64 128; do
        install -Dm444 "app/linux/icons/icon$size.png" "$out/share/icons/hicolor/''${size}x$size/apps/zotero.png"
      done
      install -Dm444 "app/linux/icons/symbolic.svg" "$out/share/icons/hicolor/scalable/apps/zotero-symbolic.svg"

    fi

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    mainProgram = "zotero";
    license = lib.licenses.agpl3Only;
    platforms = firefox-esr-140-unwrapped.meta.platforms;
    maintainers = with lib.maintainers; [
      atila
      justanotherariel
      mynacol
    ];
  };
})
