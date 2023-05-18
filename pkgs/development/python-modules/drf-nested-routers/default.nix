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
  version = "0.93.3";

  src = fetchFromGitHub {
    owner = "alanjds";
    repo = "drf-nested-routers";
    rev = "v${version}";
    sha256 = "1gmw6gwiqzfysx8qn7aan7xgkizxy64db94z30pm3bvn6jxv08si";
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
