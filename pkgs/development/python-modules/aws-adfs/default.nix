{ lib, buildPythonPackage, fetchPypi
, pytest, pytestrunner, pytestcov, mock, glibcLocales, lxml, boto3, requests, click, configparser }:

buildPythonPackage rec {
  version = "1.12.2";
  pname = "aws-adfs";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e35fbd33e1878310099346a95b7eb5244831c9f5f6554bca7193ac50dcd41aa3";
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

  meta = {
    description = "Command line tool to ease aws cli authentication against ADFS";
    homepage = https://github.com/venth/aws-adfs;
    license = lib.licenses.psfl;
    maintainers = [ lib.maintainers.bhipple ];
  };
}
