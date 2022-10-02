{ lib
, buildPythonPackage
, colorama
, fetchPypi
, jinja2
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "mergedb";
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2034c18dca23456c5b166b63d94300bcd8ec9f386e6cd639c2f66e141c0313f9";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyyaml
    colorama
    jinja2
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mergedb"
  ];

  meta = with lib; {
    description = "A tool/library for deep merging YAML files";
    homepage = "https://github.com/graysonhead/mergedb";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ graysonhead ];
  };
}

