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
<<<<<<< HEAD
  version = "0.12.0";
=======
  version = "0.11.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "jiter";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-d87RUXKEmZXxVQZnAvjwRKSP6F3Z+kXxg/LdY2l9B+k=";
=======
    hash = "sha256-/OSLwqSy/CkAFv0hn1zED70MRsWV8/NTrSfqP7OSRFc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
