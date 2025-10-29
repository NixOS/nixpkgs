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
  version = "0.95.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alanjds";
    repo = "drf-nested-routers";
    tag = "v${version}";
    hash = "sha256-9oB6pmhZJVvVJeueY44q9ST1JgjmK1FF8QMx7mX5ZFI=";
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
