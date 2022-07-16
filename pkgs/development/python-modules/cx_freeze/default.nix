{ stdenv, lib, buildPythonPackage, pythonOlder, fetchPypi, ncurses, importlib-metadata }:

buildPythonPackage rec {
  pname = "cx_Freeze";
  version = "6.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jzowyeM5TykGVeNG07RgkQZWswrGNHqHSZu1rTZcbnw=";
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
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A set of scripts and modules for freezing Python scripts into executables";
    homepage = "https://marcelotduarte.github.io/cx_Freeze/";
    license = licenses.psfl;
  };
}
