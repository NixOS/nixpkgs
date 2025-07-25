{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pydantic,
  hatchling,
  djangorestframework,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "drf-pydantic";
  version = "2.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "georgebv";
    repo = "drf-pydantic";
    tag = "v${version}";
    hash = "sha256-ABtSoxj/+HHq4hj4Yb6bEiyOl00TCO/9tvBzhv6afxM=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    django
    pydantic
    djangorestframework
  ];

  nativeChecksInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/georgebv/drf-pydantic/releases/tag/${src.tag}";
    description = "Use pydantic with the Django REST framework";
    homepage = "https://github.com/georgebv/drf-pydantic";
    maintainers = [ maintainers.kiara ];
    license = licenses.mit;
  };
}
