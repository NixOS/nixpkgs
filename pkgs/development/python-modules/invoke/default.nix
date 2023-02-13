{ lib
, bash
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "1.7.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QbQoNC1GaoITXVqzcRloWpiXE3Qr5G5Co6OZ1oVXkxQ=";
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
