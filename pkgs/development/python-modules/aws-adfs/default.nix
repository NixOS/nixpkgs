{ lib
, botocore
, buildPythonPackage
, click
, configparser
, fetchPypi
, fido2
, glibcLocales
, isPy27
, lxml
, mock
, pyopenssl
, pytestCheckHook
, requests
, requests-kerberos
}:

buildPythonPackage rec {
  pname = "aws-adfs";
  version = "1.24.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a78bd31477ea9988166215ae86abcbfe1413bee20373ecdf0dd170b7290db55";
  };

  propagatedBuildInputs = [
    botocore
    click
    configparser
    fido2
    lxml
    pyopenssl
    requests
    requests-kerberos
  ];

  checkInputs = [
    glibcLocales
    mock
    pytestCheckHook
  ];

  # Relax version constraint
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'coverage < 4' 'coverage' \
      --replace 'fido2>=0.8.1,<0.9.0' 'fido2>=0.8.1,<1.0.0'
  '';

  # Test suite writes files to $HOME/.aws/, or /homeless-shelter if unset
  HOME = ".";

  # Required for python3 tests, along with glibcLocales
  LC_ALL = "en_US.UTF-8";

  pythonImportsCheck = [ "aws_adfs" ];

  meta = with lib; {
    description = "Command line tool to ease aws cli authentication against ADFS";
    homepage = "https://github.com/venth/aws-adfs";
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
