{ lib
, bash
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "invoke";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0c560075b5fb29ba14dad44a7185514e94970d1b9d57dcd3723bec5fed92650";
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
