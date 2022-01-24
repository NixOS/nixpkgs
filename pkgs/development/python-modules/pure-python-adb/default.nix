{ aiofiles, buildPythonPackage, fetchPypi, lib, pythonOlder }:

buildPythonPackage rec {
  pname = "pure-python-adb";
  version = "0.3.0.dev0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kdr7w2fhgjpcf1k3l6an9im583iqkr6v8hb4q1zw30nh3bqkk0f";
  };

  propagatedBuildInputs = [ aiofiles ];
  # Disable tests as they require docker, docker-compose and a dedicated
  # android emulator
  doCheck = false;
  pythonImportsCheck = [ "ppadb.client" "ppadb.client_async" ];

  meta = with lib; {
    description = "Pure python implementation of the adb client";
    homepage = "https://github.com/Swind/pure-python-adb";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
