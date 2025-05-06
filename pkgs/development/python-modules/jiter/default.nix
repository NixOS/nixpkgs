{
  lib,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
  dirty-equals,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "jiter";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "jiter";
    tag = "v${version}";
    hash = "sha256-PiBatXGh3ahxy1Dvg1SAqA5M0bTBv8A5OjGbkqcn8C0=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  buildAndTestSubdir = "crates/jiter-python";

  nativeBuildInputs = [ rustPlatform.cargoSetupHook ];

  build-system = [ rustPlatform.maturinBuildHook ];

  buildInputs = [ libiconv ];

  pythonImportsCheck = [ "jiter" ];

  nativeCheckInputs = [
    dirty-equals
    pytestCheckHook
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };

  meta = {
    description = "Fast iterable JSON parser";
    homepage = "https://github.com/pydantic/jiter/";
    changelog = "https://github.com/pydantic/jiter/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
