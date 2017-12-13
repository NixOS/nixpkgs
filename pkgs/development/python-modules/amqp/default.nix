{ lib, fetchPypi, buildPythonPackage, pythonOlder
# buildInputs
, vine
# checkInputs
, pytest
, case
}:

buildPythonPackage rec {
  pname = "amqp";
  version = "2.2.2";
  disabled = pythonOlder "2.6";


  src = fetchPypi {
    inherit pname version;
    sha256 = "08nsr4mavmkdm6n23013lm1v81hhkhgrkdyqj2qljq7zsklsr8fb";
  };

  propagatedBuildInputs = [
    vine
  ];

  checkInputs = [
    pytest
    case
  ];

  meta = with lib; {
    description = "Low-level AMQP client for Python (fork of amqplib).";
    homepage = "http://github.com/celery/py-amqp";
    license = licenses.lgpl21;
    maintainers = with maintainers; [  ];
  };
}
