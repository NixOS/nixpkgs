{ stdenv, buildPythonPackage, fetchPypi, ncurses }:

buildPythonPackage rec {
  pname = "cx_Freeze";
  version = "6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "067bgkgx7i3kw31vaviwysbb1lk91cjw9q90vklsr7nsygjxi0fa";
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
