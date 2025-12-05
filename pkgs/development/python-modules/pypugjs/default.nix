{
  lib,
  buildPythonPackage,
  charset-normalizer,
  django,
  fetchFromGitHub,
  jinja2,
  mako,
  poetry-core,
  pyramid,
  pyramid-mako,
  pytestCheckHook,
  six,
  tornado,
}:

buildPythonPackage rec {
  pname = "pypugjs";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kakulukia";
    repo = "pypugjs";
    tag = "v${version}";
    hash = "sha256-aHTWRlRrUh4LCsNUcszce4g8C4O0A/aPZKTz6Zl0UYg=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    six
    charset-normalizer
  ];

  pythonRelaxDeps = [
    "charset-normalizer"
  ];

  nativeCheckInputs = [
    django
    jinja2
    mako
    tornado
    pyramid
    pyramid-mako
    pytestCheckHook
  ];

  pytestCheckFlags = [ "pypugjs/testsuite" ];

  pythonImportsCheck = [
    "pypugjs"
  ];

  meta = with lib; {
    description = "PugJS syntax template adapter for Django, Jinja2, Mako and Tornado templates";
    mainProgram = "pypugjs";
    homepage = "https://github.com/kakulukia/pypugjs";
    license = licenses.mit;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
