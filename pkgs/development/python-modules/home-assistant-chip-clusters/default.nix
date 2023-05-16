{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, aenum
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dacite
}:

buildPythonPackage rec {
  pname = "home-assistant-chip-clusters";
<<<<<<< HEAD
  version = "2023.6.0";
=======
  version = "2023.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "wheel";

  src = fetchPypi {
    inherit format version;
    pname = "home_assistant_chip_clusters";
    dist = "py3";
    python = "py3";
<<<<<<< HEAD
    hash = "sha256-8LYB3BEDHOj6ItfFRK7ewbhjN604xXKY0YlymNjEO+g=";
  };

  propagatedBuildInputs = [
    aenum
=======
    hash = "sha256-kRgsXKn7j736yWfyRZ0LXP+Ftac5pRLmdn1LUmTYkCw=";
  };

  propagatedBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    dacite
  ];

  pythonImportsCheck = [
    "chip.clusters"
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Python-base APIs and tools for CHIP";
    homepage = "https://github.com/home-assistant-libs/chip-wheels";
    changelog = "https://github.com/home-assistant-libs/chip-wheels/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
