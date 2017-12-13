{ lib, fetchPypi, buildPythonPackage
# buildInputs
, amqp
# checkInputs
, pytz
, pytest
, case
}:

buildPythonPackage rec {
  pname = "kombu";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jvkaaflz174fwnjf5x2s46k3jak0vrdxhnif72cw7xzkpfxjja2";
  };

  propagatedBuildInputs = [
    amqp
  ];

  checkInputs = [
    pytz
    pytest
    case
  ];

  meta = with lib; {
    description = "Messaging library for Python.";
    homepage = "https://kombu.readthedocs.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [  ];
  };
}
