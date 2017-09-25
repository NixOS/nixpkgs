{ stdenv, buildPythonPackage, fetchPypi, isPyPy, isPy35, ncurses }:

buildPythonPackage rec {
  pname = "cx_Freeze";
  version = "5.0.2";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zbx9j5z5l06bvwvlqvvn7h9dm7zjcjgxm7agbb625nymkq6cd15";
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
