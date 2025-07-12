{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  redis,

  # tests
  pygments,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "portalocker";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7CD23aKtnOifo5ml8x9PFJX1FZWPDLfKZUPO97tadJ4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ redis ];

  nativeCheckInputs = [
    pygments
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "portalocker" ];

  meta = with lib; {
    changelog = "https://github.com/wolph/portalocker/releases/tag/v${version}";
    description = "Library to provide an easy API to file locking";
    homepage = "https://github.com/WoLpH/portalocker";
    license = licenses.psfl;
    maintainers = [ ];
  };
}
