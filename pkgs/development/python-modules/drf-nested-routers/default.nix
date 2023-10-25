{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, django
, djangorestframework
, pytest
, pytest-cov
, pytest-django
, ipdb
, python
}:

buildPythonPackage rec {
  pname = "drf-nested-routers";
  version = "0.93.4";

  src = fetchFromGitHub {
    owner = "alanjds";
    repo = "drf-nested-routers";
    rev = "v${version}";
    hash = "sha256-qlXNDydoQJ9FZB6G7yV/pNmx3BEo+lvRqsfjrvlbdNY=";
  };

  propagatedBuildInputs = [ django djangorestframework setuptools ];
  nativeCheckInputs = [ pytest pytest-cov pytest-django ipdb ];

  checkPhase = ''
    ${python.interpreter} runtests.py --nolint
  '';

  meta = with lib; {
    homepage = "https://github.com/alanjds/drf-nested-routers";
    description = "Provides routers and fields to create nested resources in the Django Rest Framework";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr ];
  };
}
