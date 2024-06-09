{
  lib,
  buildPythonPackage,
  fetchPypi,
  distlib,
  pythonOlder,
  exceptiongroup,
  hatch-vcs,
  hatchling,
  cattrs,
  cmake,
  ninja,
  packaging,
  pathspec,
  pyproject-metadata,
  pytest-subprocess,
  pytestCheckHook,
  setuptools,
  tomli,
  virtualenv,
  wheel,
}:

buildPythonPackage rec {
  pname = "scikit-build-core";
  version = "0.8.2";
  pyproject = true;

  src = fetchPypi {
    pname = "scikit_build_core";
    inherit version;
    hash = "sha256-UOwkuVaMmqbicjPe6yl4kyvHmFYhKzBXXL+kBJZVxDY=";
  };

  postPatch = lib.optionalString (pythonOlder "3.11") ''
    substituteInPlace pyproject.toml \
      --replace '"error",' '"error", "ignore::UserWarning",'
  '';

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs =
    [ packaging ]
    ++ lib.optionals (pythonOlder "3.11") [
      exceptiongroup
      tomli
    ];

  passthru.optional-dependencies = {
    pyproject = [
      distlib
      pathspec
      pyproject-metadata
    ];
  };

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    cattrs
    cmake
    ninja
    pytest-subprocess
    pytestCheckHook
    setuptools
    virtualenv
    wheel
  ] ++ passthru.optional-dependencies.pyproject;

  disabledTestPaths = [
    # runs pip, requires network access
    "tests/test_custom_modules.py"
    "tests/test_pyproject_pep517.py"
    "tests/test_pyproject_pep518.py"
    "tests/test_pyproject_pep660.py"
    "tests/test_setuptools_pep517.py"
    "tests/test_setuptools_pep518.py"
    # store permissions issue in Nix:
    "tests/test_editable.py"
  ];

  pythonImportsCheck = [ "scikit_build_core" ];

  meta = with lib; {
    description = "A next generation Python CMake adaptor and Python API for plugins";
    homepage = "https://github.com/scikit-build/scikit-build-core";
    changelog = "https://github.com/scikit-build/scikit-build-core/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
