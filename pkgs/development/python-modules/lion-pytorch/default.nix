{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, torch
}:

buildPythonPackage rec {
  pname = "lion-pytorch";
<<<<<<< HEAD
  version = "0.1.2";
=======
  version = "0.0.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "lion-pytorch";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-9hdpRJvCpv3PeC7f0IXpHt6i+e6LiT0QUl5jeDGelQE=";
=======
    hash = "sha256-CSb0s3DKv/KpEmCkCR+Y8iwrLdCL9w9Pl6W46cPB420";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ torch ];

  pythonImportsCheck = [ "lion_pytorch" ];
  doCheck = false;  # no tests currently

  meta = with lib; {
    description = "Optimizer tuned by Google Brain using genetic algorithms";
    homepage = "https://github.com/lucidrains/lion-pytorch";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
