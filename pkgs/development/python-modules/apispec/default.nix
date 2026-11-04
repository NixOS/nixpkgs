{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  marshmallow,
  openapi-spec-validator,
  packaging,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "apispec";
  version = "6.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RolssMqyO06FPlKFKJN3GXOfg2NYgyu4YQ7dFNsdnAE=";
  };

  build-system = [ flit-core ];

  dependencies = [ packaging ];

  optional-dependencies = {
    marshmallow = [ marshmallow ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    openapi-spec-validator
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
