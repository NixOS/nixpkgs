{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  marshmallow,
  mock,
  openapi-spec-validator,
  packaging,
  prance,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "apispec";
  version = "6.8.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/Q7RSvcaKUnZrrlrcs4VF8tKSKXFVmfNBIO37TMVaio=";
  };

  build-system = [ flit-core ];

  dependencies = [ packaging ];

  optional-dependencies = {
    marshmallow = [ marshmallow ];
    yaml = [ pyyaml ];
    validation = [
      openapi-spec-validator
      prance
    ]
    ++ prance.optional-dependencies.osv;
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "apispec" ];

  meta = with lib; {
    changelog = "https://github.com/marshmallow-code/apispec/blob/${version}/CHANGELOG.rst";
    description = "Pluggable API specification generator with support for the OpenAPI Specification";
    homepage = "https://github.com/marshmallow-code/apispec";
    license = licenses.mit;
    maintainers = [ ];
  };
}
