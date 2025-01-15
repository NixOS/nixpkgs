{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  libiconv,
  numpy,
  pytestCheckHook,
  rustPlatform,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "blake3";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oconnor663";
    repo = "blake3-py";
    tag = version;
    hash = "sha256-Wdy/zAepuMRTyOskC6gxCFkUVCAzR05eZNO/PFjT9sE=";
  };

  postPatch = ''
    ln -s '${./Cargo.lock}' Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
  ];

  pythonImportsCheck = [ "blake3" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--generate-lockfile"
    ];
  };

  meta = {
    description = "Python bindings for the BLAKE3 cryptographic hash function";
    homepage = "https://github.com/oconnor663/blake3-py";
    changelog = "https://github.com/oconnor663/blake3-py/releases/tag/${version}";
    license = with lib.licenses; [
      cc0
      asl20
    ];
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
