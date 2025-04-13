{
  lib,
  stdenv,
  buildPythonPackage,
  distutils,
  fetchPypi,
  pythonOlder,
  ncurses,
  packaging,
  setuptools,
  filelock,
  patchelf,
  tomli,
  importlib-metadata,
  typing-extensions,
  dmgbuild,
}:

buildPythonPackage rec {
  pname = "cx-freeze";
  version = "8.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "cx_freeze";
    inherit version;
    hash = "sha256-gOH4e7FS7Q+X98ZDXgI31Eqt6Zl5knxGJ3cTIqJdVQ0=";
  };

  postPatch = ''
    sed -i /patchelf/d pyproject.toml
    # Build system requirements
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=70.1,<76" "setuptools"
  '';

  build-system = [
    setuptools
  ];

  buildInputs = [ ncurses ];

  dependencies =
    [
      distutils
      packaging
      setuptools
    ]
    ++ lib.optionals (pythonOlder "3.11") [
      tomli
    ]
    ++ lib.optionals (pythonOlder "3.10") [
      importlib-metadata
      typing-extensions
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux filelock
    ++ lib.optional stdenv.hostPlatform.isDarwin dmgbuild;

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ patchelf ])
  ];

  # Fails to find Console even though it exists on python 3.x
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
