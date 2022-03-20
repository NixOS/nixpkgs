{ lib
, bash
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4zLkneQEY/IBYxX1HfQjE4VXcr6GQ1aGFWvBj0W1zGw=";
  };

  patchPhase = ''
    sed -e 's|/bin/bash|${bash}/bin/bash|g' -i invoke/config.py
  '';

  # errors with vendored libs
  doCheck = false;

  meta = {
    description = "Pythonic task execution";
    license = lib.licenses.bsd2;
  };
}
