{
  lib,
  pythonOlder,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pyasn1,
  cryptography,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pgpy-dtc";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DigitalTrustCenter";
    repo = "PGPy_dtc";
    tag = version;
    hash = "sha256-0zv2gtgp/iGDQescaDpng1gqbgjv7iXFvtwEt3YIPy4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyasn1
    cryptography
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pgpy_dtc" ];

  meta = {
    homepage = "https://github.com/DigitalTrustCenter/PGPy_dtc";
    changelog = "https://github.com/DigitalTrustCenter/PGPy_dtc/releases/tag/${src.tag}";
    description = "Pretty Good Privacy for Python";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ networkexception ];
  };
}
