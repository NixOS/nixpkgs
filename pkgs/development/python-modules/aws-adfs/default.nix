{ lib, buildPythonPackage, fetchPypi
, pytest, pytestrunner, pytestcov, mock, glibcLocales, lxml, boto3, requests, click, configparser }:

buildPythonPackage rec {
  pname = "aws-adfs";
  version = "1.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da20c682993d87d41534ffc2be0819d924aaf230b27abbc5d1fa8ad62410bf39";
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
  propagatedBuildInputs = [ lxml boto3 requests click configparser ];

  meta = with lib; {
    description = "Command line tool to ease aws cli authentication against ADFS";
    homepage = https://github.com/venth/aws-adfs;
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
