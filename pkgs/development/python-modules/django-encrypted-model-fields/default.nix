{ buildPythonPackage
, cryptography
, django
, fetchPypi
, lib
, poetry-core
, pythonOlder }:
buildPythonPackage rec {
  pname = "django-encrypted-model-fields";
  version = "0.6.5";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i9IcVWXA1k7E29N1rTT+potNotuHHew/px/nteQiHJk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    cryptography
    django
  ];

  pythonImportsCheck = [ "encrypted_model_fields" ];

  meta = with lib; {
    description = "A set of fields that wrap standard Django fields with encryption provided by the python cryptography library";
    homepage = "https://gitlab.com/lansharkconsulting/django/django-encrypted-model-fields";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
}
