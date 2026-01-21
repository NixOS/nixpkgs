{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  redis,

  # tests
  pygments,
  pytest-cov-stub,
  pytest-rerunfailures,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "portalocker";
  version = "3.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HzAClWpUqMNzBYbFx3vxj65BSeB+rxwp/D+vTVo/iaw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ redis ];

  nativeCheckInputs = [
    pygments
    pytest-cov-stub
    pytest-rerunfailures
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "portalocker" ];

  meta = {
    changelog = "https://github.com/wolph/portalocker/releases/tag/v${version}";
    description = "Library to provide an easy API to file locking";
    homepage = "https://github.com/WoLpH/portalocker";
    license = lib.licenses.psfl;
    maintainers = [ ];
  };
}
