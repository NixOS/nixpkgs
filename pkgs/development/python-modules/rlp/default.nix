{
  lib,
  fetchFromGitHub,
  setuptools,
  buildPythonPackage,
  eth-utils,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rlp";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "pyrlp";
    rev = "v${version}";
    hash = "sha256-cRp+ZOPYs9kcqMKGaiYMOFBY+aPCyFqu+1/5wloLwqU=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ eth-utils ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rlp" ];

  meta = with lib; {
    description = "RLP serialization library";
    homepage = "https://github.com/ethereum/pyrlp";
    license = licenses.mit;
    maintainers = [ ];
  };
}
