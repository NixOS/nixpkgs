{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "httpagentparser";
  version = "1.9.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U879nWWZD2/lnAN4ytjqG53493DS6L2dh2LtrgM76Ao=";
  };

  # PyPi version does not include test directory
  doCheck = false;

  pythonImportsCheck = [
    "httpagentparser"
  ];

  meta = with lib; {
    description = "Module to extract OS, Browser, etc. information from http user agent string";
    homepage = "https://github.com/shon/httpagentparser";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
