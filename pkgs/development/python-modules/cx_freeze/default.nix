{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, ncurses }:

buildPythonPackage rec {
  pname = "cx_Freeze";
  version = "6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44bbbcea3196b79da77cc22637cb28a825b51182d32209e8a3f6cd4042edc247";
  };

  disabled = pythonOlder "3.5";

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
