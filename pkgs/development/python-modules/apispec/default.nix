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
  version = "6.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s45EeZFtQ/Kx6IzhX8L66TrfLo1Vy1nsdKxmqCeUFIM=";
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
    ] ++ prance.optional-dependencies.osv;
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
    maintainers = with maintainers; [ ];
  };
}
