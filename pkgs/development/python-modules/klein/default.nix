{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  attrs,
  hyperlink,
  incremental,
  tubes,
  twisted,
  werkzeug,
  zope-interface,

  # tests
  idna,
  python,
  treq,
}:

buildPythonPackage rec {
  pname = "klein";
  version = "24.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "twisted";
    repo = "klein";
    rev = "refs/tags/${version}";
    hash = "sha256-2/zl4fS9ZP73quPmGnz2+brEt84ODgVS89Om/cUsj0M=";
  };

  build-system = [
    incremental
    setuptools
  ];

  dependencies = [
    attrs
    hyperlink
    incremental
    twisted
    tubes
    werkzeug
    zope-interface
  ];

  nativeCheckInputs = [
    idna
    treq
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m twisted.trial klein
    runHook postCheck
  '';

  pythonImportsCheck = [ "klein" ];

  meta = with lib; {
    changelog = "https://github.com/twisted/klein/releases/tag/${version}";
    description = "Klein Web Micro-Framework";
    homepage = "https://github.com/twisted/klein";
    license = licenses.mit;
    maintainers = with maintainers; [ exarkun ];
  };
}
