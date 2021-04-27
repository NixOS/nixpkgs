{ lib, jdk11, fetchFromGitHub, buildPythonPackage, docopt, psutil, pythonOlder }:

buildPythonPackage rec {
  pname = "adb-enhanced";
  version = "2.5.11";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "ashishb";
    repo = pname;
    rev = version;
    sha256 = "sha256-jb5O7Qxk2xAX5sax6nqywcGBJao5Xfff9s1yvdfvDCs=";
  };

  postPatch = ''
    substituteInPlace adbe/adb_enhanced.py \
      --replace "cmd = 'java" "cmd = '${jdk11}/bin/java"
  '';

  propagatedBuildInputs = [ psutil docopt ];

  # Disable tests because they require a dedicated android emulator
  doCheck = false;

  pythonImportsCheck = [ "adbe" ];

  meta = with lib; {
    description = "Tool for Android testing and development";
    homepage = "https://github.com/ashishb/adb-enhanced";
    license = licenses.asl20;
    maintainers = with maintainers; [ vtuan10 ];
    mainProgram = "adbe";
  };
}
