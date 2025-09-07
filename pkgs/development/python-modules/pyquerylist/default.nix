{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  tabulate,
  coverage,
  flake8,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "pyquerylist";
  version = "0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "markmuetz";
    repo = "pyquerylist";
    # no recent releases including the pytest rewrite
    tag = "v${version}";
    hash = "sha256-ZhXFnzCKhcFPH8ayxwnDucD6v4E1y0jIk+3SeARAHlw=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    tabulate
  ];

  pythonImportsCheck = [ "pyquerylist" ];

  nativeCheckInputs = [
    coverage
    flake8
    pytestCheckHook
  ];

  meta = {
    description = "Extension of base Python list that you can query";
    homepage = "https://github.com/markmuetz/pyquerylist";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philipwilk ];
  };
}
