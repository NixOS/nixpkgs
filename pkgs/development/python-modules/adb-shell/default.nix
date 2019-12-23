{ lib, buildPythonPackage, fetchFromGitHub, pytest, cryptography, pyasn1, rsa, pycryptodome, mock }:

buildPythonPackage rec {
  pname = "adb_shell";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "JeffLIrion";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m2l8khl9cjq5vzf748ywpwkvdcvfdb4bj3s3vqcjd40sc5rpslx";
  };

  propagatedBuildInputs = [ cryptography pyasn1 rsa ];

  checkInputs = [ pytest pycryptodome mock ];

  checkPhase = ''
    pytest tests/
    '';

  meta = with lib; {
    homepage = "https://github.com/JeffLIrion/adb_shell";
    description = "A Python implementation of ADB with shell and FileSync functionality";
    license = licenses.asl20;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
