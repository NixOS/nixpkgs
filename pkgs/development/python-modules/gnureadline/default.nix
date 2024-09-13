{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  pkgs,
}:

buildPythonPackage rec {
  version = "8.2.10";
  format = "setuptools";
  pname = "gnureadline";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p0a6mNTeN7B55C2Um3BMM8FoswvR+QcaHSXJ2ppEmZc=";
  };

  buildInputs = [ pkgs.ncurses ];
  patchPhase = ''
    substituteInPlace setup.py --replace "/bin/bash" "${pkgs.bash}/bin/bash"
  '';

  meta = with lib; {
    description = "Standard Python readline extension statically linked against the GNU readline library";
    homepage = "https://github.com/ludwigschwardt/python-gnureadline";
    license = licenses.gpl3;
  };
}
