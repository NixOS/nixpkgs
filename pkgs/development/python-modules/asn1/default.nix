{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, future
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asn1";
  version = "2.6.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "andrivet";
    repo = "python-asn1";
    rev = "v${version}";
    sha256 = "sha256-oz9xZhFU4himXttVtfW6tTn7lfB0c7MlgxtbKxdJtUA=";
  };

  propagatedBuildInputs = [
    future
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "enum-compat" ""
  '';

  pytestFlagsArray = [ "tests/test_asn1.py" ];

  pythonImportsCheck = [ "asn1" ];

  meta = with lib; {
    description = "Python ASN.1 encoder and decoder";
    homepage = "https://github.com/andrivet/python-asn1";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
