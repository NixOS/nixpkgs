{
  lib,
  fetchFromGitHub,
  stdenv,
  openssl,
  pkg-config,
  nix-update-script,
  versionCheckHook,
}:
let
  platformName = if stdenv.hostPlatform.isLinux then "linux" else "macos";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zsign";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "zhlynn";
    repo = "zsign";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NuwV8s+rzsXBha/vqnemvUo6Etm70ZVYL/CZKBJ1szA=";
  };

  sourceRoot = "${finalAttrs.src.name}/build/${platformName}";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  makeFlags = [
    "BINDIR=bin/"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "VERSION=${finalAttrs.version}"
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform codesign alternative for iOS 12+";
    homepage = "https://github.com/zhlynn/zsign";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pascalj ];
    mainProgram = "zsign";
    platforms = with lib.platforms; darwin ++ linux;
  };
})
