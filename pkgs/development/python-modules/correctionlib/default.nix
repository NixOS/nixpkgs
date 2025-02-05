{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  cmake,
  scikit-build,
  setuptools,
  setuptools-scm,
  pybind11,

  zlib,

  # dependencies
  numpy,
  packaging,
  pydantic,
  rich,

  # checks
  awkward,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "correctionlib";
  version = "2.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cms-nanoAOD";
    repo = "correctionlib";
    tag = "v${version}";
    hash = "sha256-l+JjW/giGzU00z0jBN3D4KB/LjTIxeJb3CS+Ge0gbiA=";
    fetchSubmodules = true;
  };

  patches = [
    # fix https://github.com/Tencent/rapidjson/issues/2277
    (fetchpatch {
      url = "https://github.com/Tencent/rapidjson/pull/719.diff";
      hash = "sha256-xarSfi9o73KoJo0ijT0G8fyTSYVuY0+9rLEtfUwas0Q=";
      extraPrefix = "rapidjson/";
      stripLen = 1;
    })
  ];

  build-system = [
    cmake
    scikit-build
    setuptools
    setuptools-scm
    pybind11
  ];

  buildInputs = [ zlib ];

  dependencies = [
    numpy
    packaging
    pydantic
    rich
  ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    awkward
    pytestCheckHook
    scipy
  ];

  pythonImportsCheck = [ "correctionlib" ];

  # One test requires running the produced `correctionlib` binary
  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = {
    description = "Provides a well-structured JSON data format for a wide variety of ad-hoc correction factors encountered in a typical HEP analysis";
    mainProgram = "correction";
    homepage = "https://cms-nanoaod.github.io/correctionlib/";
    changelog = "https://github.com/cms-nanoAOD/correctionlib/releases/tag/v${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
