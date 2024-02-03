{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, ncurses
, importlib-metadata
, setuptools
, wheel
, patchelf
}:

buildPythonPackage rec {
  pname = "cx-freeze";
  version = "6.15.7";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "cx_Freeze";
    inherit version;
    hash = "sha256-+X9FWkpG7gwHbZIqKftT7/RioWXdBCP6J+J8KkRTtAs=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    importlib-metadata # upstream has this for 3.8 as well
    ncurses
    setuptools
  ];

  postPatch = ''
    # timestamp need to come after 1980 for zipfiles and nix store is set to epoch
    substituteInPlace cx_Freeze/freezer.py --replace "st.st_mtime" "time.time()"

    sed -i /patchelf/d pyproject.toml
    substituteInPlace pyproject.toml \
      --replace 'setuptools>=61.2,<67' setuptools
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ patchelf ])
  ];

  # fails to find Console even though it exists on python 3.x
  doCheck = false;

  meta = with lib; {
    description = "A set of scripts and modules for freezing Python scripts into executables";
    homepage = "https://marcelotduarte.github.io/cx_Freeze/";
    license = licenses.psfl;
    maintainers = with maintainers; [ ];
    mainProgram = "cxfreeze";
  };
}
