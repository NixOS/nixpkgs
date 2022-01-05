{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "dotmap";
  version = "1.3.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cc87300f3a61d70f2bd18103ea2747dea846a2381a8321f43ce65cbd7afdfe3d";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "dotmap/test.py" ];

  pythonImportsCheck = [ "dotmap" ];

  meta = with lib; {
    description = "Python for dot-access dictionaries";
    homepage = "https://github.com/drgrib/dotmap";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
