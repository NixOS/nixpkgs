{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, django, futures, mock, jinja2, jsmin, slimit }:

buildPythonPackage rec {
  pname = "django-pipeline";
  version = "1.6.14";

  # no tests on PyPI
  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = version;
    sha256 = "1xf732bd17mgha75jfhlnms46ib2pffhpfa0ca7bmng9jhbvsl9j";
  };

  postPatch = ''
    substituteInPlace tests/tests/test_compiler.py \
      --replace "/usr/bin/env" ""
  '';

  propagatedBuildInputs = [ django ] ++ lib.optional (!isPy3k) futures;

  checkInputs = [ jinja2 jsmin slimit ] ++ lib.optional (!isPy3k) mock;

  checkPhase = ''
    export PYTHONPATH=.:$PYTHONPATH
    export DJANGO_SETTINGS_MODULE=tests.settings
    ${django}/bin/django-admin.py test tests
  '';

  meta = with lib; {
    description = "Pipeline is an asset packaging library for Django";
    homepage = https://github.com/cyberdelia/django-pipeline;
    license = licenses.mit;
  };
}
