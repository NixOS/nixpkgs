{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  django,
  djangorestframework,
  ujson,

  # tests
  pytest-django,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "drf-ujson2";
  version = "1.7.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Amertz08";
    repo = "drf_ujson2";
    rev = "refs/tags/v${version}";
    hash = "sha256-kbpZN1zOXHvRPcn+Sjbelq74cWgvCUeMXZy1eFSa6rA=";
  };

  postPatch = ''
    sed -i '/--cov/d' setup.cfg
  '';

  buildInputs = [ django ];

  propagatedBuildInputs = [
    djangorestframework
    ujson
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    pytest-django
    pytest-mock
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/Amertz08/drf_ujson2/releases/tag/v${version}";
    description = "JSON parser and renderer using ujson for Django Rest Framework";
    homepage = "https://github.com/Amertz08/drf_ujson2";
    maintainers = with maintainers; [ hexa ];
  };
}
