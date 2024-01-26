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
  version = "2.5.22";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ashishb";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-n1CME/swV+NsZdUfWwVY1qQeYzawwy+sm0mkRPQKm6A=";
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
