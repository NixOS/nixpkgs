{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  scikit-build,
  cmake,
  ninja,
  python,
  flaky,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "picologging";
  version = "0.9.4";
  pyproject = true;

  src = fetchFromGitHub {
    # 0.9.4 only release on github
    owner = "microsoft";
    repo = "picologging";
    tag = version;
    hash = "sha256-t75D7aNKAifzeCPwtyKp8LoiXtbbXspRFYnsI0gx+V4=";
  };

  patches = [
    # For python 313
    # https://github.com/microsoft/picologging/pull/212
    ./pr-212.patch
  ];

  build-system = [
    setuptools
    cmake
    scikit-build
    ninja
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  dontUseCmakeConfigure = true;
  __darwinAllowLocalNetworking = true;

  dependencies = [
    flaky
    hypothesis
  ];

  pythonImportsCheck = [ "picologging" ];

  meta = {
    homepage = "https://github.com/microsoft/picologging";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    changelog = "https://github.com/microsoft/picologging/releases/tag/${version}";
    description = "Optimized logging library for Python";
    license = lib.licenses.mit;
  };
}
