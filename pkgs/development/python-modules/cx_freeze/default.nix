{ lib, buildPythonPackage, pythonOlder, fetchPypi, ncurses, importlib-metadata }:

buildPythonPackage rec {
  pname = "cx_Freeze";
  version = "6.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f16d3d40f7f2e1f6032132170d8fd4ba2f4f9ea419f13d7a68091bbe1949583";
  };

  disabled = pythonOlder "3.5";

  propagatedBuildInputs = [
    importlib-metadata # upstream has this for 3.8 as well
    ncurses
  ];

  # timestamp need to come after 1980 for zipfiles and nix store is set to epoch
  prePatch = ''
    substituteInPlace cx_Freeze/freezer.py --replace "os.stat(module.file).st_mtime" "time.time()"
  '';

  # fails to find Console even though it exists on python 3.x
  doCheck = false;

  meta = with lib; {
    description = "A set of scripts and modules for freezing Python scripts into executables";
    homepage = "http://cx-freeze.sourceforge.net/";
    license = licenses.psfl;
  };
}
