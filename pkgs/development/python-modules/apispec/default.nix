{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, marshmallow
, mock
, openapi-spec-validator
, packaging
, prance
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools
}:

buildPythonPackage rec {
  pname = "apispec";
  version = "6.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wDpNhIrnDpuyJp3U5NMNjsfsBp0k756bQi48vRqf55Q=";
  };

  nativeBuildInputs = [
    flit-core
  ];

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
