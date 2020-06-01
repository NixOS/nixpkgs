{ lib
, bash
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dae041ff458e1ef05448aae3b76e8c2a176c4b7c6a9d5e8ce880f16251803661";
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
