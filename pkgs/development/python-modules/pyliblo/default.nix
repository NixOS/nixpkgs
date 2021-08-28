{ lib
, buildPythonPackage
, fetchurl
, isPyPy
, liblo
, cython
}:

buildPythonPackage rec {
  pname = "pyliblo";
  version = "0.10.0";
  disabled = isPyPy;

  src = fetchurl {
    url = "http://das.nasophon.de/download/${pname}-${version}.tar.gz";
    sha256 = "13vry6xhxm7adnbyj28w1kpwrh0kf7nw83cz1yq74wl21faz2rzw";
  };

  buildInputs = [ liblo cython ];

  meta = with lib; {
    homepage = "http://das.nasophon.de/pyliblo/";
    description = "Python wrapper for the liblo OSC library";
    license = licenses.lgpl21;
  };

}
