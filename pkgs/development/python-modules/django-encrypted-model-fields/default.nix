{
  buildPythonPackage,
  cryptography,
  django,
  fetchPypi,
  lib,
  poetry-core,
}:
buildPythonPackage rec {
  pname = "django-encrypted-model-fields";
  version = "0.6.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i9IcVWXA1k7E29N1rTT+potNotuHHew/px/nteQiHJk=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    cryptography
    django
  ];

  pythonImportsCheck = [ "encrypted_model_fields" ];

  meta = {
    description = "Set of fields that wrap standard Django fields with encryption provided by the python cryptography library";
    homepage = "https://gitlab.com/lansharkconsulting/django/django-encrypted-model-fields";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ centromere ];
  };
}
