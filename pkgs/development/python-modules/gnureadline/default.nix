{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  pkgs,
}:

buildPythonPackage rec {
  version = "8.3.3";
  format = "setuptools";
  pname = "gnureadline";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CXI5K9LzEkTi2YEXgkb+i3Kch2ZFT9rrJ1lGrEe36f0=";
  };

  buildInputs = [ pkgs.ncurses ];
  patchPhase = ''
    substituteInPlace setup.py --replace "/bin/bash" "${pkgs.bash}/bin/bash"
  '';

  meta = {
    description = "Standard Python readline extension statically linked against the GNU readline library";
    homepage = "https://github.com/ludwigschwardt/python-gnureadline";
    license = lib.licenses.gpl3;
  };
}
