{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "colorclass";
  version = "2.2.0";

  src = fetchFromGitHub {
     owner = "Robpol86";
     repo = "colorclass";
     rev = "v2.2.0";
     sha256 = "1c9r7v888wavaq8mhzihg42rlfynwzvgw95r5h7sjkqz2zd1pf4b";
  };

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/Robpol86/colorclass";
    license = licenses.mit;
    description = "Automatic support for console colors";
  };
}
