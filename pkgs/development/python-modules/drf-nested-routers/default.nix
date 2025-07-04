{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  djangorestframework,
  pytestCheckHook,
  pytest-django,
  ipdb,
}:

buildPythonPackage rec {
  pname = "drf-nested-routers";
  version = "0.94.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alanjds";
    repo = "drf-nested-routers";
    tag = "v${version}";
    hash = "sha256-ETRj14xoSv3fGXggg+P7651ZhbsEkxUaTO7ZPpKidRA=";
  };

  buildInputs = [ django ];

  propagatedBuildInputs = [ djangorestframework ];

  nativeCheckInputs = [
    ipdb
    pytestCheckHook
    pytest-django
  ];

  meta = with lib; {
    homepage = "https://github.com/alanjds/drf-nested-routers";
    changelog = "https://github.com/alanjds/drf-nested-routers/blob/v${version}/CHANGELOG.md";
    description = "Provides routers and fields to create nested resources in the Django Rest Framework";
    license = licenses.asl20;
    maintainers = with maintainers; [ felschr ];
  };
}
