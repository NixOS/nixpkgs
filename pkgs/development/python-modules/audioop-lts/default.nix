{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "audioop-lts";
  version = "0.2.2";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "AbstractUmbra";
    repo = "audioop";
    tag = version;
    hash = "sha256-C1z24kH5t0RSVqjT8SBdrilMtVs7pTI1vd+iwMk3RXE=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -rf audioop
  '';

  pythonImportsCheck = [
    "audioop"
  ];

  meta = {
    changelog = "https://github.com/AbstractUmbra/audioop/releases/tag/${version}";
    description = "LTS port of Python's `audioop` module";
    homepage = "https://github.com/AbstractUmbra/audioop";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
