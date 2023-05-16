{ lib, buildPythonPackage, fetchFromGitHub, sphinx, packaging }:

buildPythonPackage rec {
  pname = "pallets-sphinx-themes";
<<<<<<< HEAD
  version = "2.1.1";
=======
  version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "pallets-sphinx-themes";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    sha256 = "sha256-Z03rsqkwF2rYaqRZflf5qc5EdHPIEcEcB1ftYIm5DQs=";
=======
    sha256 = "sha256-u1sHeO0fk11+M5M0yqDcWsMJKBMeAGW+GPOgu1oniok=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ packaging sphinx ];

  pythonImportsCheck = [ "pallets_sphinx_themes" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pallets/pallets-sphinx-themes";
    description = "Sphinx theme for Pallets projects";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kaction ];
  };
}
