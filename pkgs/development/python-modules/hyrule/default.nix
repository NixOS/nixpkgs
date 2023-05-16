{ lib
, buildPythonPackage
, fetchFromGitHub
, hy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hyrule";
<<<<<<< HEAD
  version = "0.4.0";
=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hylang";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-D5d/WwGSbEmSeyVBTIpGOqi+I6PkRdo8dhDaCeeOW4M=";
=======
    hash = "sha256-nQAUVX409RWlFPeknnNwFNgo7e2xHkEXkAuXazZNntk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    hy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Some tests depends on hy on PATH
  preCheck = "PATH=${hy}/bin:$PATH";

  pythonImportsCheck = [ "hyrule" ];

  meta = with lib; {
    description = "Hyrule is a utility library for the Hy programming language";
    homepage = "https://github.com/hylang/hyrule";
    changelog = "https://github.com/hylang/hylure/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ thiagokokada ];
  };
}
