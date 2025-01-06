{
  lib,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  future,
  numpy,
  pytest-lazy-fixture,
  pytestCheckHook,
  pythonOlder,
  scikit-build,
  setuptools,
}:

buildPythonPackage rec {
  pname = "parselmouth";
  version = "0.4.4";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "YannickJadoul";
    repo = "Parselmouth";
    # Stable branch with cherry picked changes to fit to the newer dependencies versions https://github.com/YannickJadoul/Parselmouth/issues/130
    rev = "c2cbecc0ce4a0b5d3052cc6c6fbddf4bf133655d";
    fetchSubmodules = true;
    hash = "sha256-+6id0PVfpiVjee7O4ZoskNK0dz5ZmTYRTtum3B3tIgE=";
  };

  configurePhase = ''
    # doesn't happen automatically
    export MAKEFLAGS=-j$NIX_BUILD_CORES
  '';

  build-system = [
    cmake
    scikit-build
    setuptools
  ];

  dontUseCmakeConfigure = true;

  dependencies = [ numpy ];

  nativeCheckInputs = [
    future
    pytest-lazy-fixture
    pytestCheckHook
  ];

  pythonImportsCheck = [ "parselmouth" ];

  meta = {
    description = "Praat in Python, the Pythonic way";
    homepage = "https://github.com/YannickJadoul/Parselmouth";
    changelog = "https://github.com/YannickJadoul/Parselmouth/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
