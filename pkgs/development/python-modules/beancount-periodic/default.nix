{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  unittestCheckHook,
  setuptools,
  beancount,
  beangulp,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "beancount-periodic";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dallaslu";
    repo = "beancount-periodic";
    tag = "v${version}";
    hash = "sha256-XuBDKG/iOS0gyfiwEEPjIckAbnfOKHjYwXW4CmUy8eA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beancount
    beangulp
    python-dateutil
  ];

  nativeCheckInputs = [ unittestCheckHook ];
  unittestFlags = [
    "-v"
    "tests"
  ];

  pythonImportsCheck = [ "beancount_periodic" ];

  meta = {
    description = "Beancount plugin to generate periodic transactions";
    homepage = "https://github.com/dallaslu/beancount-periodic";
    license = with lib.licenses; [ unlicense ];
    maintainers = with lib.maintainers; [ polyfloyd ];
  };
}
