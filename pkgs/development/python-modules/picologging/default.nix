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
    rev = "refs/tags/${version}";
    hash = "sha256-t75D7aNKAifzeCPwtyKp8LoiXtbbXspRFYnsI0gx+V4=";
  };

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
    description = "optimized logging library for Python";
    license = lib.licenses.mit;
  };
}
