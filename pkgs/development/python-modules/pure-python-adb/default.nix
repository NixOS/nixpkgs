{
  aiofiles,
  buildPythonPackage,
  fetchPypi,
  lib,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pure-python-adb";
  version = "0.3.0.dev0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DsyJ14AWDP4DJguibfLEcaBSY7LK0DGDY1c+6AQ/uU0=";
  };

  passthru.optional-dependencies = {
    async = [ aiofiles ];
  };

  doCheck = pythonOlder "3.10"; # all tests result in RuntimeError on 3.10

  nativeCheckInputs = [ pytestCheckHook ] ++ passthru.optional-dependencies.async;

  pythonImportsCheck = [ "ppadb.client" ] ++ lib.optionals doCheck [ "ppadb.client_async" ];

  meta = with lib; {
    description = "Pure python implementation of the adb client";
    homepage = "https://github.com/Swind/pure-python-adb";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
