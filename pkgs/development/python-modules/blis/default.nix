{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  hypothesis,
  numpy,
  pytestCheckHook,
  pythonOlder,
  blis,
  numpy_1,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "blis";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cython-blis";
    tag = "release-v${version}";
    hash = "sha256-krUqAEPxJXdlolSbV5R0ZqrWaFuXh7IxSeFTsCr6iss=";
  };

  preCheck = ''
    # remove src module, so tests use the installed module instead
    rm -rf ./blis
  '';

  build-system = [
    setuptools
    cython
    numpy
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "blis" ];

  passthru = {
    tests = {
      numpy_1 = blis.overridePythonAttrs (old: {
        numpy = numpy_1;
      });
    };
    updateScript = gitUpdater {
      rev-prefix = "release-v";
    };
  };

  meta = with lib; {
    changelog = "https://github.com/explosion/cython-blis/releases/tag/release-${src.tag}";
    description = "BLAS-like linear algebra library";
    homepage = "https://github.com/explosion/cython-blis";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nickcao ];
  };
}
