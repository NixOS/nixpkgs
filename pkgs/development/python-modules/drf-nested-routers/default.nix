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
  version = "0.92.5";

  src = fetchFromGitHub {
    owner = "alanjds";
    repo = "drf-nested-routers";
    rev = "v${version}";
    sha256 = "1l1jza8xz6xcm3gwxh1k6pc8fs95cq3v751gxj497y1a83d26j8i";
  };

  propagatedBuildInputs = [ django djangorestframework setuptools ];
  checkInputs = [ pytest pytest-cov pytest-django ipdb ];

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
