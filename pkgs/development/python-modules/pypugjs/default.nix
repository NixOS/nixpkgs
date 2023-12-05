{ lib
, buildPythonPackage
, charset-normalizer
, django
, fetchFromGitHub
, jinja2
, mako
, nose
, pyramid
, pyramid-mako
, pytestCheckHook
, six
, tornado
}:

buildPythonPackage rec {
  pname = "pypugjs";
  version = "5.9.12";

  src = fetchFromGitHub {
    owner = "kakulukia";
    repo = "pypugjs";
    rev = "v${version}";
    hash = "sha256-6tIhKCa8wg01gNFygCS6GdUHfbWBu7wOZeMkCExRR34=";
  };

  propagatedBuildInputs = [ six charset-normalizer ];

  nativeCheckInputs = [
    django
    jinja2
    mako
    nose
    tornado
    pyramid
    pyramid-mako
    pytestCheckHook
  ];

  pytestCheckFlags = [
    "pypugjs/testsuite"
  ];

  meta = with lib; {
    description = "PugJS syntax template adapter for Django, Jinja2, Mako and Tornado templates";
    homepage = "https://github.com/kakulukia/pypugjs";
    license = licenses.mit;
    maintainers = with maintainers; [ lopsided98 ];
  };
}
