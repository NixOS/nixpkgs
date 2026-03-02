{
  lib,
  fetchFromGitHub,
  stdenv,
  openssl,
  pkg-config,
  minizip,
  zlib,
  versionCheckHook,
}:
let
  platformName = if stdenv.hostPlatform.isLinux then "linux" else "macos";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zsign";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "zhlynn";
    repo = "zsign";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CAG9ewROyIGN5VOZbs0X1W88HdZ3H1sxaRJ7JpDbw3o=";
  };

  sourceRoot = "${finalAttrs.src.name}/build/${platformName}";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    minizip
    zlib
  ];

  makeFlags = [
    "BINDIR=bin/"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    cp bin/zsign $out/bin/

    runHook postInstall
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Cross-platform codesign alternative for iOS 12+";
    homepage = "https://github.com/zhlynn/zsign";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pascalj ];
    mainProgram = "zsign";
    platforms = with lib.platforms; darwin ++ linux;
  };
})
