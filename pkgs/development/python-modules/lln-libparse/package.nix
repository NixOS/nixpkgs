{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  pybind11,
  unstableGitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "lln-libparse";
  version = "0-unstable-2026-11-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "librelane";
    repo = "libparse-python";
    rev = "217cf61bca05dcbb3c1438e29acbc4a16611caf7";
    fetchSubmodules = true;
    hash = "sha256-99GSEDj7+dw2O/PFgidVpeRXNlDeAPiXRX3ChweoRS8=";
  };

  postPatch = ''
    substituteInPlace yosys/passes/techmap/libparse.cc \
        --replace-fail \
          "void LibertyParser::error" \
          "__attribute__((weak)) void LibertyParser::error"
  '';

  build-system = [
    pybind11
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "libparse" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Python library for parsing Yosys output";
    homepage = "https://github.com/librelane/libparse-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gonsolo ];
    platforms = lib.platforms.unix;
  };
})
