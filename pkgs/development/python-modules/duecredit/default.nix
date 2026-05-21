{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest-cov-stub,
  vcrpy,
  citeproc-py,
  looseversion,
  requests,
}:

buildPythonPackage rec {
  pname = "duecredit";
  version = "0.11.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e1wa4Qkn+eAs9NVOLHSoqgDNKcONY33v48lI09jp8zo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    citeproc-py
    looseversion
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    vcrpy
  ];
  disabledTests = [ "test_import_doi" ]; # tries to access network

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "duecredit" ];

  meta = {
    homepage = "https://github.com/duecredit/duecredit";
    description = "Simple framework to embed references in code";
    mainProgram = "duecredit";
    changelog = "https://github.com/duecredit/duecredit/releases/tag/${version}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
