{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  docker,
  openssl,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "wrkflw";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "wrkflw";
    tag = "v${version}";
    hash = "sha256-ErzlAVRyDyRo/AAbTjuBhuQtveRttB0ArUugIGuYMiY=";
  };

  cargoHash = "sha256-SbX0jWaihabl90L7KfRfFakvTDIpJcDjsfOr36T8+Xg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    docker
    openssl
  ];

  # Tests require docker daemon running
  doCheck = false;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GitHub Actions workflow validator and executor";
    homepage = "https://github.com/bahdotsh/wrkflw";
    license = lib.licenses.mit;
    mainProgram = "wrkflw";
    maintainers = with lib.maintainers; [ FKouhai ];
    platforms = lib.platforms.linux;
  };
}
