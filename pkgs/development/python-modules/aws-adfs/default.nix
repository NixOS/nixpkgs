{ lib, buildPythonPackage, fetchPypi
, pytest, pytestrunner, pytestcov, mock, glibcLocales, lxml, boto3
, requests, click, configparser, fido2, isPy27 }:

buildPythonPackage rec {
  pname = "aws-adfs";
  version = "1.20.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j18ffq5z8bcajavnlpbfhxrcadld5iv5gsfxg543yvdsp6hn2dg";
  };

  # Relax version constraint
  patchPhase = ''
    sed -i 's/coverage < 4/coverage/' setup.py
  '';

  # Test suite writes files to $HOME/.aws/, or /homeless-shelter if unset
  HOME = ".";

  # Required for python3 tests, along with glibcLocales
  LC_ALL = "en_US.UTF-8";

  checkInputs = [ glibcLocales pytest pytestrunner pytestcov mock ];
  propagatedBuildInputs = [ lxml boto3 requests click configparser fido2 ];

  meta = with lib; {
    description = "Command line tool to ease aws cli authentication against ADFS";
    homepage = https://github.com/venth/aws-adfs;
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
