{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  future,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "asn1";
  version = "2.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "andrivet";
    repo = "python-asn1";
    rev = "refs/tags/v${version}";
    hash = "sha256-pXLG2Mkrv6EeJn6Dk+SefzNtrPdQ6of95LbVTKjTADQ=";
  };

  propagatedBuildInputs = [ future ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "enum-compat" ""
  '';

  pytestFlagsArray = [ "tests/test_asn1.py" ];

  pythonImportsCheck = [ "asn1" ];

  meta = with lib; {
    description = "Python ASN.1 encoder and decoder";
    homepage = "https://github.com/andrivet/python-asn1";
    changelog = "https://github.com/andrivet/python-asn1/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
