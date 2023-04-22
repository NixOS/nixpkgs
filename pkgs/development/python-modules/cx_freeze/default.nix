{ stdenv, lib, buildPythonPackage, pythonOlder, fetchPypi, ncurses, importlib-metadata }:

buildPythonPackage rec {
  pname = "cx-freeze";
  version = "6.14.4";

  src = fetchPypi {
    pname = "cx_Freeze";
    inherit version;
    hash = "sha256-ydox+o4B0t/dYD+nDiY5CmWupt1iMzyU2fA4tCqgVcg=";
  };

  disabled = pythonOlder "3.5";

  propagatedBuildInputs = [
    importlib-metadata # upstream has this for 3.8 as well
    ncurses
  ];

  # timestamp need to come after 1980 for zipfiles and nix store is set to epoch
  postPatch = ''
    substituteInPlace cx_Freeze/freezer.py --replace "os.stat(module.file).st_mtime" "time.time()"

    substituteInPlace setup.cfg \
      --replace "setuptools>=59.0.1,<=60.10.0" "setuptools>=59.0.1"
  '';

  # fails to find Console even though it exists on python 3.x
  doCheck = false;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A set of scripts and modules for freezing Python scripts into executables";
    homepage = "https://marcelotduarte.github.io/cx_Freeze/";
    license = licenses.psfl;
  };
}
