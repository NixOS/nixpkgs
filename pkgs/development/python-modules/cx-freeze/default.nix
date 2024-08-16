{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  ncurses,
  setuptools,
  filelock,
  typing-extensions,
  wheel,
  patchelf,
}:

buildPythonPackage rec {
  pname = "cx-freeze";
  version = "7.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "cx_freeze";
    inherit version;
    hash = "sha256-M1wwutDj5lNlXyMJkzCEWL7cmXuvW3qZXoZB3rousoc=";
  };

  pythonRelaxDeps = [
    "setuptools"
    "wheel"
  ];

  build-system = [
    setuptools
    wheel
  ];

  buildInputs = [
    ncurses
  ];

  dependencies = [
    filelock
    setuptools
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  postPatch = ''
    sed -i /patchelf/d pyproject.toml
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
    description = "Set of scripts and modules for freezing Python scripts into executables";
    homepage = "https://marcelotduarte.github.io/cx_Freeze/";
    changelog = "https://github.com/marcelotduarte/cx_Freeze/releases/tag/${version}";
    license = licenses.psfl;
    maintainers = [ ];
    mainProgram = "cxfreeze";
  };
}
