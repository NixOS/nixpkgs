{
  lib,
  buildPythonPackage,
  cython,
  expandvars,
  fetchFromGitHub,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "propcache";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "propcache";
    rev = "refs/tags/v${version}";
    hash = "sha256-S0u5/HJYtZCWB9X+Nlnz+oSFb3o98mGWWwsNLodzS9g=";
  };

  build-system = [
    cython
    expandvars
    setuptools
  ];

  nativeCheckInputs = [
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
