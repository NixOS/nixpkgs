{ lib
, buildPythonPackage
, docopt
, fetchFromGitHub
, jdk11
, psutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "adb-enhanced";
<<<<<<< HEAD
  version = "2.5.22";
=======
  version = "2.5.18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ashishb";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-n1CME/swV+NsZdUfWwVY1qQeYzawwy+sm0mkRPQKm6A=";
=======
    hash = "sha256-xsl8AentI4Tqo2mHWFRi6myyb0/MemATJz9erKN9eKQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    psutil
    docopt
  ];

  postPatch = ''
    substituteInPlace adbe/adb_enhanced.py \
      --replace "cmd = 'java" "cmd = '${jdk11}/bin/java"
  '';

  # Disable tests because they require a dedicated Android emulator
  doCheck = false;

  pythonImportsCheck = [
    "adbe"
  ];

  meta = with lib; {
    description = "Tool for Android testing and development";
    homepage = "https://github.com/ashishb/adb-enhanced";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = licenses.asl20;
    maintainers = with maintainers; [ vtuan10 ];
    mainProgram = "adbe";
  };
}
