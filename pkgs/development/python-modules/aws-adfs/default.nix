{ lib, buildPythonPackage, fetchPypi
, pytest, pytestrunner, pytestcov, mock, glibcLocales, lxml, botocore
, requests, requests-kerberos, click, configparser, fido2, isPy27 }:

buildPythonPackage rec {
  pname = "aws-adfs";
  version = "1.24.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "601b056fa8ba4b615289def3b1aa49aa58f1f4aa6b89f3cf7cf1e0aee9f2291c";
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

  meta = with lib; {
    description = "Command line tool to ease aws cli authentication against ADFS";
    homepage = "https://github.com/venth/aws-adfs";
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
