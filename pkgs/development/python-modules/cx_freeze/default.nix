{ stdenv, buildPythonPackage, fetchPypi, ncurses }:

buildPythonPackage rec {
  pname = "cx_Freeze";
  version = "6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0181bdb0ed16b292f4cfb8cd3afc84e956fc187431f25392bd981460dd73da0";
  };

  propagatedBuildInputs = [ ncurses ];

  # timestamp need to come after 1980 for zipfiles and nix store is set to epoch
  prePatch = ''
    substituteInPlace cx_Freeze/freezer.py --replace "os.stat(module.file).st_mtime" "time.time()"
  '';

  # fails to find Console even though it exists on python 3.x
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A set of scripts and modules for freezing Python scripts into executables";
    homepage = "http://cx-freeze.sourceforge.net/";
    license = licenses.psfl;
  };
}
