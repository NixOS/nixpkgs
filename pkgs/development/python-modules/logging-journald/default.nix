{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "logging-journald";
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U6kqAvMSyLDbThc6wAN/ri0vmt/vAxgFFZT65Csbpss=";
  };

  # Circular dependency with aiomisc
  doCheck = false;

  pythonImportsCheck = [
    "logging_journald"
  ];

  meta = with lib; {
    description = "Logging handler for writing logs to the journald";
    homepage = "https://github.com/mosquito/logging-journald";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
