{ lib
, buildPythonPackage
, fetchPypi
, marshmallow
, mock
, openapi-spec-validator
, packaging
, prance
, pytestCheckHook
, pythonOlder
, pyyaml
}:

buildPythonPackage rec {
  pname = "apispec";
  version = "6.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iB07kL//3tZZvApL8J6t7t+iVs0nFyaxVV11r54Kmmk=";
  };

  propagatedBuildInputs = [
    packaging
  ];

  passthru.optional-dependencies = {
    marshmallow = [
      marshmallow
    ];
    yaml = [
      pyyaml
    ];
    validation = [
      openapi-spec-validator
      prance
    ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "apispec"
  ];

  meta = with lib; {
    changelog = "https://github.com/marshmallow-code/apispec/blob/${version}/CHANGELOG.rst";
    description = "A pluggable API specification generator with support for the OpenAPI Specification";
    homepage = "https://github.com/marshmallow-code/apispec";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
