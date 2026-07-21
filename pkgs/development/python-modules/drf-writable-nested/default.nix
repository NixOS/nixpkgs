{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  djangorestframework,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage (finalAttrs: {
  pname = "drf-writable-nested";
  version = "0.7.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "beda-software";
    repo = "drf-writable-nested";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VkQ3Di3vXxQAmvuMP8KpGVVdx7LMYcQFEF4ZsuA9KeA=";
  };

  propagatedBuildInputs = [
    django
    djangorestframework
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = {
    description = "Writable nested model serializer for Django REST Framework";
    homepage = "https://github.com/beda-software/drf-writable-nested";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
