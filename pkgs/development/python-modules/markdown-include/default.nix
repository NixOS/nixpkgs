{ lib
, buildPythonPackage
, fetchPypi
, markdown
}:

buildPythonPackage rec {
  pname = "markdown-include";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18p4qfhazvskcg6xsdv1np8m1gc1llyabp311xzhqy7p6q76hpbg";
  };

  propagatedBuildInputs = [
    markdown
  ];

  pythonImportsCheck = [
    "markdown_include"
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Extension to Python-Markdown which provides an include function";
    homepage = "https://github.com/cmacmackin/markdown-include";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
