{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, numpy
,
}:

buildPythonPackage rec {
  pname = "pyfastnoisesimd";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-S6KCepnp20w4LxVB5gOnUmtzbGJ1Xs982PSQr6XBAW0";
  };

  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  meta = {
    description = "Python module wrapping C++ FastNoiseSIMD";
    homepage = "https://github.com/robbmcleod/pyfastnoisesimd";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ n3rdium ];
  };
}
