{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "pypng";
  version = "0.0.21";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "drj11";
    repo = "pypng";
    rev = "refs/tags/${pname}-${version}";
    sha256 = "sha256-JU1GCSTm2s6Kczn6aRcF5DizPJVpizNtnAMJxTBi9vo=";
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
