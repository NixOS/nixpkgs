{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "mpv";
  version = "0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b9kd70mshdr713f3l1lbnz1q0vlg2y76h5d8liy1bzqm7hjcgfw";
  };

  buildInputs = [ pkgs.mpv ];
  patchPhase = "substituteInPlace mpv.py --replace libmpv.so ${pkgs.mpv}/lib/libmpv.so";

  meta = with stdenv.lib; {
    description = "A python interface to the mpv media player";
    homepage = "https://github.com/jaseg/python-mpv";
    license = licenses.agpl3;
  };

}
