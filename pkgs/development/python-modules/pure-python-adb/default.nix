{
  aiofiles,
  buildPythonPackage,
  fetchPypi,
  lib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pure-python-adb";
  version = "0.3.0.dev0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DsyJ14AWDP4DJguibfLEcaBSY7LK0DGDY1c+6AQ/uU0=";
  };

  optional-dependencies = {
    async = [ aiofiles ];
  };

  doCheck = false; # all tests result in RuntimeError

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.async;

  pythonImportsCheck = [ "ppadb.client" ] ++ lib.optionals doCheck [ "ppadb.client_async" ];

  meta = {
    description = "Pure python implementation of the adb client";
    homepage = "https://github.com/Swind/pure-python-adb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
