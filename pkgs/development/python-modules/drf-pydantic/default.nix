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
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "georgebv";
    repo = "drf-pydantic";
    tag = "v${version}";
    hash = "sha256-RvDTequtxHyCsXV8IpNWdYNzdjkKEr8aAyS3ZFZTW1A=";
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
