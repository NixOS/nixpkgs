{ lib
, fetchFromGitHub
, buildPythonPackage
, pyparsing
, six
, urwid
}:

buildPythonPackage rec {
  pname = "configshell";
<<<<<<< HEAD
  version = "1.1.30";
=======
  version = "1.1.29";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7iWmYVCodwncoPdpw85zrNsZSEq+ume412lyiiJqRPc=";
=======
    sha256 = "0mjj3c9335sph8rhwww7j4zvhyk896fbmx887vibm89w3jpvjjr9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyparsing
    six
    urwid
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyparsing >=2.0.2,<3.0" "pyparsing >=2.0.2"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "configshell"
  ];

  meta = with lib; {
    description = "Python library for building configuration shells";
    homepage = "https://github.com/open-iscsi/configshell-fb";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
