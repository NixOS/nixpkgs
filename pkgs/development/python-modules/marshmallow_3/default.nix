{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  flit-core,

  # tests
  pytestCheckHook,
  pytz,
  simplejson,
}:

buildPythonPackage rec {
  pname = "marshmallow";
  # nixpkgs-update: no auto update
  version = "3.26.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5tiv+2y2HTnSZAIJbcCu4S1aJtSQoSHxGNLoHcBxncY=";
  };

  build-system = [ flit-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    simplejson
  ];

  disabledTests = [
    "test_from_timestamp_with_overflow_value"
  ];

  pythonImportsCheck = [ "marshmallow" ];

  passthru.skipBulkUpdate = true;

  meta = {
    description = "Library for converting complex objects to and from simple Python datatypes";
    homepage = "https://github.com/marshmallow-code/marshmallow";
    changelog = "https://github.com/marshmallow-code/marshmallow/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfroche ];
  };
}
