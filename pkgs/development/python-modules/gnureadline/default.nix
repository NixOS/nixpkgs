{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  version = "6.3.3";
  pname = "gnureadline";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ghck2zz4xbqa3wz73brgjhrqj55p9hc1fq6c9zb09dnyhwb0nd2";
  };

  buildInputs = [ pkgs.ncurses ];
  patchPhase = ''
    substituteInPlace setup.py --replace "/bin/bash" "${pkgs.bash}/bin/bash"
  '';

  meta = with stdenv.lib; {
    description = "The standard Python readline extension statically linked against the GNU readline library";
    homepage = http://github.com/ludwigschwardt/python-gnureadline;
    license = licenses.gpl3;
  };

}
