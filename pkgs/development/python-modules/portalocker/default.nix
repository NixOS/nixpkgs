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
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "portalocker";
  version = "2.10.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7xv4ROh4qwiu5+QBhBVuEVHyKPEDqlxr0HJMwzCWD48=";
  };

  postPatch = ''
    sed -i "/--cov/d" pytest.ini
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [ redis ];

  nativeCheckInputs = [
    pygments
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
