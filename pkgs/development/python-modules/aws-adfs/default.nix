{ lib, buildPythonPackage, fetchPypi
, pytest, pytestrunner, pytestcov, mock, glibcLocales, lxml, boto3
, requests, click, configparser, fido2, isPy27 }:

buildPythonPackage rec {
  pname = "aws-adfs";
  version = "1.21.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "18c93a1a8c6462d042ad5dc204c7449766b8e13fe11db51da269ec9e1dc8091e";
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
