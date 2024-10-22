{
  lib,
  buildPythonPackage,
  charset-normalizer,
  django,
  fetchFromGitHub,
  jinja2,
  mako,
  pyramid,
  pyramid-mako,
  pytestCheckHook,
  six,
  tornado,
}:

buildPythonPackage rec {
  pname = "pypugjs";
  version = "5.10.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kakulukia";
    repo = "pypugjs";
    rev = "refs/tags/v${version}";
    hash = "sha256-W+EVNxT2OimNENHe4lJDn6Wm1EbBysGuCD3/Wkdew/U=";
  };

  propagatedBuildInputs = [
    six
    charset-normalizer
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

  meta = with lib; {
    description = "PugJS syntax template adapter for Django, Jinja2, Mako and Tornado templates";
    mainProgram = "pypugjs";
    homepage = "https://github.com/kakulukia/pypugjs";
    license = licenses.mit;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
