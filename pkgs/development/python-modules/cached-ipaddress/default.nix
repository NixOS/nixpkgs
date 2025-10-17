{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  poetry-core,
  pytest-codspeed,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  propcache,
}:

buildPythonPackage rec {
  pname = "cached-ipaddress";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "cached-ipaddress";
    tag = "v${version}";
    hash = "sha256-/bq9RZcC6VDK5JxT1QcAJpWNmioNqOearYc34KsCvHs=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ propcache ];

  nativeCheckInputs = [
    pytest-codspeed
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cached_ipaddress" ];

  meta = with lib; {
    description = "Cache construction of ipaddress objects";
    homepage = "https://github.com/bdraco/cached-ipaddress";
    changelog = "https://github.com/bdraco/cached-ipaddress/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
