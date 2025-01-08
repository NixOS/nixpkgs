{
  lib,
  buildPythonPackage,
  cython,
  expandvars,
  fetchFromGitHub,
  pytest-codspeed,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "propcache";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "propcache";
    rev = "refs/tags/v${version}";
    hash = "sha256-j2PjSaOx0IKijoMjhtYVNrpqEwRjVFsON5OU/Fv5idc=";
  };

  build-system = [
    cython
    expandvars
    setuptools
  ];

  nativeCheckInputs = [
    pytest-codspeed
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "propcache" ];

  meta = {
    description = "Fast property caching";
    homepage = "https://github.com/aio-libs/propcache";
    changelog = "https://github.com/aio-libs/propcache/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
