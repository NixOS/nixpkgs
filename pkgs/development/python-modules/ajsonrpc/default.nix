{ lib, pythonOlder, buildPythonPackage, fetchPypi, pytestCheckHook }:

buildPythonPackage rec {
  pname = "ajsonrpc";
  version = "1.2.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ajsonrpc" ];

  meta = with lib; {
    description = "Async JSON-RPC 2.0 protocol + asyncio server";
    homepage = "https://github.com/pavlov99/ajsonrpc";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
