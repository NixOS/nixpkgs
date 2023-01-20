{ lib
, buildPythonPackage
, fetchPypi
, unittestCheckHook
, pymeta3
}:

buildPythonPackage rec {
  pname = "pybars3";
  version = "0.9.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ashH6QXlO5xbk2rxEskQR14nv3Z/efRSjBb5rx7A4lI=";
  };

  propagatedBuildInputs = [ pymeta3 ];

  checkInputs = [ unittestCheckHook ];

  preCheck = ''
    rm tests.py
  '';

  pythonImportsCheck = [
    "pybars"
  ];

  meta = with lib; {
    description = "Handlebars.js for Python 3 and 2";
    homepage = "https://github.com/wbond/pybars3";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ tmarkus ];
  };
}
