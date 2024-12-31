{
  lib,
  buildPythonPackage,
  distutils,
  fetchPypi,
  pythonOlder,
  ncurses,
  packaging,
  setuptools,
  filelock,
  wheel,
  typing-extensions,
  patchelf,
}:

buildPythonPackage rec {
  pname = "cx-freeze";
  version = "7.2.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "cx_freeze";
    inherit version;
    hash = "sha256-6bLEvWjr9PuZtq8v8oHA5TewSa7pSIBcxKAo4XGKvGo=";
  };

  postPatch = ''
    sed -i /patchelf/d pyproject.toml
    # Build system requirements
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=70.1,<75" "setuptools"
  '';

  build-system = [
    setuptools
    wheel
  ];

  buildInputs = [ ncurses ];

  dependencies =
    [
      distutils
      filelock
      packaging
      setuptools
      wheel
    ]
    ++ lib.optionals (pythonOlder "3.10") [
      typing-extensions
    ];

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
