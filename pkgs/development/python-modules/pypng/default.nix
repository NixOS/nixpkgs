{ lib
, buildPythonPackage
, fetchFromGitLab
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pypng";
  version = "0.20220715.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "drj11";
    repo = "pypng";
    rev = "refs/tags/${pname}-${version}";
    hash = "sha256-tTnsGCAmHexDWm/T5xpHpcBaQcBEqMfTFaoOAeC+pDs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [ "png" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pure Python library for PNG image encoding/decoding";
    homepage = "https://github.com/drj11/pypng";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
