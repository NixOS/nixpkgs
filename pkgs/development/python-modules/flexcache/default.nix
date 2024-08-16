{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,
  wheel,

  # dependencies
  typing-extensions,

  # checks
  pytestCheckHook,
  pytest-mpl,
  pytest-subtests,
}:

buildPythonPackage rec {
  pname = "flexcache";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "flexcache";
    rev = version;
    hash = "sha256-MAbTe7NxzfRPzo/Wnb5SnPJvJWf6zVeYsaw/g9OJYSE=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mpl
    pytest-subtests
  ];

  pythonImportsCheck = [ "flexcache" ];

  meta = with lib; {
    description = "An robust and extensible package to cache on disk the result of expensive calculations";
    homepage = "https://github.com/hgrecco/flexcache";
    changelog = "https://github.com/hgrecco/flexcache/blob/${src.rev}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ doronbehar ];
  };
}
