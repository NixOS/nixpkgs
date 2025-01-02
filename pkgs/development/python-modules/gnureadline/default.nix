{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  pkgs,
}:

buildPythonPackage rec {
  version = "8.2.13";
  format = "setuptools";
  pname = "gnureadline";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ybnh57qZqAu1DBICfWzmkldPd6Zb9XvJcEHPgcD0m9E=";
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
