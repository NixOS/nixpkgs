{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "biplist";
  version = "1.0.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-TAVJdkxf5QsoBC7CGqLhT+GiIk4jmh2ud9nn85MqpMY=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Failing tests
    "testConvertToXMLPlistWithData"
    "testWriteToFile"
    "testXMLPlist"
    "testXMLPlistWithData"
  ];

  pythonImportsCheck = [ "biplist" ];

  meta = {
    homepage = "https://bitbucket.org/wooster/biplist/src/master/";
    description = "Binary plist parser/generator for Python";
    longDescription = ''
      Binary Property List (plist) files provide a faster and smaller
      serialization format for property lists on OS X.

      This is a library for generating binary plists which can be read
      by OS X, iOS, or other clients.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ siriobalmelli ];
  };
})
