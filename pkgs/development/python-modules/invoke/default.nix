{ lib
, bash
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dr1a5qbb9z5hyns4zk086zm0iqbms33zv0s1296wx502y7jyjfw";
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
