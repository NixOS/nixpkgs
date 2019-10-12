{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  version = "8.0.0";
  pname = "gnureadline";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xllr43dizvybmb68i0ybk1xhaqx5abjwxa9vrg43b9ds0pggvk1";
  };

  buildInputs = [ pkgs.ncurses ];
  patchPhase = ''
    substituteInPlace setup.py --replace "/bin/bash" "${pkgs.bash}/bin/bash"
  '';

  meta = with stdenv.lib; {
    description = "The standard Python readline extension statically linked against the GNU readline library";
    homepage = https://github.com/ludwigschwardt/python-gnureadline;
    license = licenses.gpl3;
  };

}
