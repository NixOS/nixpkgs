{ lib, buildPythonPackage, fetchPypi
, pytest, pytestrunner, pytestcov, mock, glibcLocales, lxml, botocore
, requests, requests-kerberos, click, configparser, fido2, isPy27 }:

buildPythonPackage rec {
  pname = "aws-adfs";
  version = "1.24.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a78bd31477ea9988166215ae86abcbfe1413bee20373ecdf0dd170b7290db55";
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
  propagatedBuildInputs = [ botocore lxml requests requests-kerberos click configparser fido2 ];

  pythonImportsCheck = [ "aws_adfs" ];

  meta = with lib; {
    description = "Command line tool to ease aws cli authentication against ADFS";
    homepage = "https://github.com/venth/aws-adfs";
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
