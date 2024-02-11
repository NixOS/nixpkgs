{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pydantic
, phonenumbers
, pycountry
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pydantic-extra-types";
  version = "2.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-extra-types";
    rev = "v${version}";
    hash = "sha256-QPBOHIssTsWQlEg2WRpLRKrB6zmae43EExnPn5P4oAY=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    pydantic
  ];

  passthru.optional-dependencies = {
    all = [
      phonenumbers
      pycountry
    ];
  };

  pythonImportsCheck = [ "pydantic_extra_types" ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.all;

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
  ];

  meta = with lib; {
    description = "Extra Pydantic types";
    homepage = "https://github.com/pydantic/pydantic-extra-types";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
