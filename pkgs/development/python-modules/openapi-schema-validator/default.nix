{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pythonOlder

# build-system
, poetry-core

# propagates
, jsonschema
, jsonschema-specifications
, rfc3339-validator

# tests
, pytestCheckHook
=======
, poetry-core
, pytestCheckHook
, isodate
, jsonschema
, rfc3339-validator
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "openapi-schema-validator";
<<<<<<< HEAD
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

=======
  version = "0.4.4";
  format = "pyproject";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-859v6KqIRfUq4d/KbkvGnGqlxz6BXTl+tKQHPhtkTH0=";
=======
    hash = "sha256-2XTCdp9dfzhNKCpq71pt7yEZm9abiEmFHD/114W+jOQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    jsonschema
<<<<<<< HEAD
    jsonschema-specifications
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    rfc3339-validator
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "openapi_schema_validator" ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/python-openapi/openapi-schema-validator/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Validates OpenAPI schema against the OpenAPI Schema Specification v3.0";
    homepage = "https://github.com/p1c2u/openapi-schema-validator";
    license = licenses.bsd3;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
