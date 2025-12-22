{ lib
, buildPythonPackage
, fetchPypi
, numpy
}:

buildPythonPackage rec {
  pname = "pyfastnoisesimd";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-S6KCepnp20w4LxVB5gOnUmtzbGJ1Xs982PSQr6XBAW0";
  };

  format = "setuptools";
  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "Python module wrapping C++ FastNoiseSIMD";
    homepage = "https://github.com/robbmcleod/pyfastnoisesimd";
    license = licenses.bsd3;
    maintainers = with maintainers; [ n3rdium ];
  };
}
