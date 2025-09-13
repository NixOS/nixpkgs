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
  version = "0.4.6";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "YannickJadoul";
    repo = "Parselmouth";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-ish9FQWdDCJ54S3s3ELZa40ttCs3opTRtFAQNg9lEIM=";
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

  pytestFlags = [
    "--run-praat-tests"
    "-v"
  ];

  pythonImportsCheck = [ "parselmouth" ];

  meta = {
    description = "Praat in Python, the Pythonic way";
    homepage = "https://github.com/YannickJadoul/Parselmouth";
    changelog = "https://github.com/YannickJadoul/Parselmouth/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
