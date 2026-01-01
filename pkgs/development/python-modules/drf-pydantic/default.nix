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
<<<<<<< HEAD
  version = "2.9.1";
=======
  version = "2.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "georgebv";
    repo = "drf-pydantic";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/dMhKlAMAh63JlhanfSfe15ECMZvtnd1huD8L3Xo2AQ=";
=======
    hash = "sha256-RvDTequtxHyCsXV8IpNWdYNzdjkKEr8aAyS3ZFZTW1A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/georgebv/drf-pydantic/releases/tag/${src.tag}";
    description = "Use pydantic with the Django REST framework";
    homepage = "https://github.com/georgebv/drf-pydantic";
    maintainers = [ lib.maintainers.kiara ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/georgebv/drf-pydantic/releases/tag/${src.tag}";
    description = "Use pydantic with the Django REST framework";
    homepage = "https://github.com/georgebv/drf-pydantic";
    maintainers = [ maintainers.kiara ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
