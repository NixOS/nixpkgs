{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  tabulate,
  coverage,
  flake8,
  pytest,
  pytestCheckHook,
  fetchpatch,
}:
buildPythonPackage rec {
  pname = "pyquerylist";
  version = "0-unstable-2025-03-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markmuetz";
    repo = "pyquerylist";
    rev = "1de783a7eddbe0726c6bf49c90153f1130c18ef8";
    hash = "sha256-ZhXFnzCKhcFPH8ayxwnDucD6v4E1y0jIk+3SeARAHlw=";
  };

  propagatedBuildInputs = [
    tabulate
  ];

  pythonImportsCheck = [ "pyquerylist" ];

  nativeCheckInputs = [
    coverage
    flake8
    pytest
    pytestCheckHook
  ];

  build-system = [
    setuptools
    wheel
  ];

  meta = {
    description = "Extension of base Python list that you can query";
    homepage = "https://github.com/markmuetz/pyquerylist";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philipwilk ];
  };
}
