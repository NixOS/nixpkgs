{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  version = "6.3.8";
  pname = "gnureadline";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ddhj98x2nv45iz4aadk4b9m0b1kpsn1xhcbypn5cd556knhiqjq";
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
