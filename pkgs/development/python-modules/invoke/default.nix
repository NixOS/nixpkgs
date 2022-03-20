{ lib
, bash
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "1.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4zLkneQEY/IBYxX1HfQjE4VXcr6GQ1aGFWvBj0W1zGw=";
  };

  patchPhase = ''
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
