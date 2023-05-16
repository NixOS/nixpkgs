{ lib
, buildPythonPackage
, fetchFromGitHub
, pamqp
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioamqp";
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Polyconseil";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-fssPknJn1tLtzb+2SFyZjfdhUdD8jqkwlInoi5uaplk=";
  };

  propagatedBuildInputs = [
    pamqp
  ];

  # Tests assume rabbitmq server running
  doCheck = false;

  pythonImportsCheck = [
    "aioamqp"
  ];

  meta = with lib; {
    description = "AMQP implementation using asyncio";
    homepage = "https://github.com/polyconseil/aioamqp";
    license = licenses.bsd3;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
