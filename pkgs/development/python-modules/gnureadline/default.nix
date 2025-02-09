{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  version = "8.1.2";
  format = "setuptools";
  pname = "gnureadline";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QmKmqjVqsi72QvQ6f5TrQqctbwxTLttOjGuTP1cwVtI=";
  };

  buildInputs = [ pkgs.ncurses ];
  patchPhase = ''
    substituteInPlace setup.py --replace "/bin/bash" "${pkgs.bash}/bin/bash"
  '';

  meta = with lib; {
    description = "The standard Python readline extension statically linked against the GNU readline library";
    homepage = "https://github.com/ludwigschwardt/python-gnureadline";
    license = licenses.gpl3;
  };

}
