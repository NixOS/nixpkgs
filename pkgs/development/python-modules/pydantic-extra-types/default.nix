{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pydantic
, pendulum
, phonenumbers
, pycountry
, python-ulid
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pydantic-extra-types";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-extra-types";
    rev = "refs/tags/v${version}";
    hash = "sha256-XLVhoZ3+TfVYEuk/5fORaGpCBaB5NcuskWhHgt+llS0=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pydantic
  ];

  passthru.optional-dependencies = {
    all = [
      pendulum
      phonenumbers
      pycountry
      python-ulid
    ];
  };

  pythonImportsCheck = [ "pydantic_extra_types" ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.all;

  meta = with lib; {
    changelog = "https://github.com/pydantic/pydantic-extra-types/blob/${src.rev}/HISTORY.md";
    description = "Extra Pydantic types";
    homepage = "https://github.com/pydantic/pydantic-extra-types";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
