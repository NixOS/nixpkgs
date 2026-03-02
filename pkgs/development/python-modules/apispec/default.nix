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
  pyyaml,
}:

buildPythonPackage rec {
  pname = "apispec";
  version = "6.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ejjOfD7tx3cebjMpWv3YxLCs3ZhltIP4z2zDack+jR4=";
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
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "apispec" ];

  meta = {
    changelog = "https://github.com/marshmallow-code/apispec/blob/${version}/CHANGELOG.rst";
    description = "Pluggable API specification generator with support for the OpenAPI Specification";
    homepage = "https://github.com/marshmallow-code/apispec";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
