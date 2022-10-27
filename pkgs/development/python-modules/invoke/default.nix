{ lib
, bash
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "1.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e23q9YXu4KhIIF0LjAAUub9vKHqOt5iBimQt/x3xSxk=";
  };

  postPatch = ''
    sed -e 's|/bin/bash|${bash}/bin/bash|g' -i invoke/config.py
  '';

  # errors with vendored libs
  doCheck = false;

  pythonImportsCheck = [
    "invoke"
  ];

  meta = with lib; {
    description = "Pythonic task execution";
    homepage = "https://www.pyinvoke.org/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
