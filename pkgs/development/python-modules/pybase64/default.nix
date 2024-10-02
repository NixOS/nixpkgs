{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pybase64";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cU8CHD6qKHwQl87Wjy30xbLs0lBFUcLnHIQ/VDZaygM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pybase64" ];

  meta = with lib; {
    description = "Fast Base64 encoding/decoding";
    mainProgram = "pybase64";
    homepage = "https://github.com/mayeut/pybase64";
    changelog = "https://github.com/mayeut/pybase64/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = [ ];
  };
}
