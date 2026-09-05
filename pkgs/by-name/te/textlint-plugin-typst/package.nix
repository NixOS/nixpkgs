{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  symlinks,
  nodejs-slim,
  textlint,
  textlint-plugin-typst,
  textlint-rule-max-comma,
}:

let
  pname = "textlint-plugin-typst";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "textlint";
    repo = "textlint-plugin-typst";
    rev = "v${version}";
    hash = "sha256-ILS/uv+/0aePOduDBm04P/G6Y/PiouUl4zv9RI7OsdY=";
  };

  bunDeps = stdenvNoCC.mkDerivation {
    pname = "${pname}-bun-deps";
    inherit version src;

    nativeBuildInputs = [
      bun
      symlinks
    ];

    dontConfigure = true;

    installPhase = ''
      runHook preInstall

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      bun install --force --frozen-lockfile --ignore-scripts --no-progress

      # Converting an absolute path symbolic link to a relative path
      symlinks -cr $BUN_INSTALL_CACHE_DIR

      mkdir -p $out
      cp -r $BUN_INSTALL_CACHE_DIR/* $out/

      runHook postInstall
    '';

    # Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

    outputHash = "sha256-L7Seb00ZDuVGlAIRvLFQ6s85vrFwvYXyAq+ZvKD3Vb0=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    bun
  ];

  configurePhase = ''
    runHook preConfigure

    # BUN_INSTALL_CACHE_DIR must be writable
    export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
    cp -r ${bunDeps}/* $BUN_INSTALL_CACHE_DIR

    bun install --frozen-lockfile --ignore-scripts --no-progress

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    local pkgdir="$out/lib/node_modules/${pname}"
    mkdir -p $pkgdir

    cp -r lib $pkgdir
    cp package.json $pkgdir

    rm -r node_modules
    bun install --frozen-lockfile --ignore-scripts --no-progress --prod
    cp -r node_modules $pkgdir

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    inherit (textlint-plugin-typst) pname;
    rule = textlint-rule-max-comma;
    plugin = textlint-plugin-typst;
    testFile = ./test.typ;
  };

  meta = {
    description = "Textlint plugin to lint Typst";
    homepage = "https://github.com/textlint/textlint-plugin-typst";
    changelog = "https://github.com/textlint/textlint-plugin-typst/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yadokani389 ];
    platforms = nodejs-slim.meta.platforms;
  };
}
