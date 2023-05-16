{ lib
, buildPythonPackage
, fetchFromGitHub
, prompt-toolkit
, pythonOlder
, winacl
}:

buildPythonPackage rec {
  pname = "aiowinreg";
<<<<<<< HEAD
  version = "0.0.10";
=======
  version = "0.0.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "skelsec";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-PkrBjH+yeSLpwL9kH242xQKBsjv6a11k2c26qBwR6Fw=";
=======
    hash = "sha256-FyrYqNqp0PTEHHit3Rn00jtvPOvgVy+lz3jDRJnsobI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    prompt-toolkit
    winacl
  ];

  # Project doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "aiowinreg"
  ];

  meta = with lib; {
    description = "Python module to parse the registry hive";
    homepage = "https://github.com/skelsec/aiowinreg";
    changelog = "https://github.com/skelsec/aiowinreg/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
