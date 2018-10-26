{ stdenv
, buildPythonPackage
, fetchurl
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  pname = "pyliblo";
  version = "0.9.2";
  disabled = isPyPy;

  src = fetchurl {
    url = "http://das.nasophon.de/download/${pname}-${version}.tar.gz";
    sha256 = "382ee7360aa00aeebf1b955eef65f8491366657a626254574c647521b36e0eb0";
  };

  propagatedBuildInputs = [ pkgs.liblo ];

  meta = with stdenv.lib; {
    homepage = http://das.nasophon.de/pyliblo/;
    description = "Python wrapper for the liblo OSC library";
    license = licenses.lgpl21;
  };

}
