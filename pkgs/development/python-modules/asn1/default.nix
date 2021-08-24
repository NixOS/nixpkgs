{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, future
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "asn1";
  version = "2.4.1";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "andrivet";
    repo = "python-asn1";
    rev = "v${version}";
    sha256 = "0g2d5cr1pxsm5ackba7padf7gvlgrgv807kh0312s5axjd2cww2l";
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
