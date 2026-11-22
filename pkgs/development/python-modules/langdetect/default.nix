{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  six,
}:

buildPythonPackage rec {
  pname = "langdetect";
  version = "1.0.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-y8H++J+NBic5d0vVHto9oydABrNmHRmcJlX2s/bWBaA=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "langdetect" ];

  meta = {
    description = "Python port of Google's language-detection library";
    homepage = "https://github.com/Mimino666/langdetect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erikarvstedt ];
  };
}
