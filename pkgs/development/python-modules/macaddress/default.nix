{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  hypothesis,
  reprshed,
}:

buildPythonPackage rec {
  pname = "macaddress";
  version = "2.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mentalisttraceur";
    repo = "python-macaddress";
    rev = "v${version}";
    hash = "sha256-2eD5Ui8kUduKLJ0mSiwaz7TQSeF1+2ASirp70V/8+EA=";
  };

  pythonImportsCheck = [ "macaddress" ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    reprshed
  ];

  pytestFlagsArray = [ "test.py" ];

  meta = with lib; {
    homepage = "https://github.com/mentalisttraceur/python-macaddress";
    description = "Module for handling hardware identifiers like MAC addresses";
    license = licenses.bsd0;
    maintainers = with maintainers; [ netali ];
  };
}
