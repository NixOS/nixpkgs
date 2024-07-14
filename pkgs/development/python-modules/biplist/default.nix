{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "biplist";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TAVJdkxf5QsoBC7CGqLhT+GiIk4jmh2ud9nn85MqpMY=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Failing tests
    "testConvertToXMLPlistWithData"
    "testWriteToFile"
    "testXMLPlist"
    "testXMLPlistWithData"
  ];

  pythonImportsCheck = [ "biplist" ];

  meta = with lib; {
    homepage = "https://bitbucket.org/wooster/biplist/src/master/";
    description = "Binary plist parser/generator for Python";
    longDescription = ''
      Binary Property List (plist) files provide a faster and smaller
      serialization format for property lists on OS X.

      This is a library for generating binary plists which can be read
      by OS X, iOS, or other clients.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
