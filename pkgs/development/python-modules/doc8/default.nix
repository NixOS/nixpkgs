{ lib
, buildPythonPackage
, chardet
, docutils
, fetchPypi
, pbr
, pygments
, pytestCheckHook
, pythonOlder
, restructuredtext_lint
, setuptools-scm
, stevedore
}:

buildPythonPackage rec {
  pname = "doc8";
  version = "1.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HpmaFP5BXqltidUFPHkNAQYfGbZzdwa4F9FXnCoHzBY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    docutils
    chardet
    stevedore
    restructuredtext_lint
    pygments
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "doc8"
  ];

  meta = with lib; {
    description = "Style checker for Sphinx (or other) RST documentation";
    homepage = "https://github.com/pycqa/doc8";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
