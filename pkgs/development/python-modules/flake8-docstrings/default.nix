{ lib
, buildPythonPackage
, fetchPypi
, flake8
, pydocstyle
}:

buildPythonPackage rec {
  pname = "flake8-docstrings";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fe7c6a306064af8e62a055c2f61e9eb1da55f84bb39caef2b84ce53708ac34b";
  };

  propagatedBuildInputs = [ flake8 pydocstyle ];

  pythonImportsCheck = [ "flake8_docstrings" ];

  meta = with lib; {
    description = "Extension for flake8 which uses pydocstyle to check docstrings";
    homepage = "https://gitlab.com/pycqa/flake8-docstrings";
    license = licenses.mit;
    maintainers = with maintainers; [ smaret ];
  };
}
