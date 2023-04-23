{ lib, buildPythonPackage, fetchFromGitHub, six, timecop }:

buildPythonPackage rec {
  pname = "onetimepass";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "tadeck";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wmv62l3r8r4428gdzyj80lhgadfqvj220khz1wnm9alyzg60wkh";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    timecop
  ];

  pythonImportsCheck = [ "onetimepass" ];

  meta = with lib; {
    description = "One-time password library for HMAC-based (HOTP) and time-based (TOTP) passwords";
    homepage = "https://github.com/tadeck/onetimepass";
    license = licenses.mit;
    maintainers = with maintainers; [ zakame ];
  };
}
