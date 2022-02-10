{ lib
, buildPythonPackage
, colorclass
, easygui
, fetchFromGitHub
, msoffcrypto-tool
, olefile
, pcodedmp
, pyparsing
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "oletools";
  version = "0.60";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "decalage2";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gatUVkf8iT1OGnahX1BzQLDypCqhS1EvkAgUHJ6myA4=";
  };

  propagatedBuildInputs = [
    colorclass
    easygui
    msoffcrypto-tool
    olefile
    pcodedmp
    pyparsing
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyparsing>=2.1.0,<3" "pyparsing>=2.1.0"
  '';

  disabledTests = [
    # Test fails with AssertionError: Tuples differ: ('MS Word 2007+...
    "test_all"
  ];

  pythonImportsCheck = [
    "oletools"
  ];

  meta = with lib; {
    description = "Python tool to analyze MS OLE2 files and MS Office documents";
    homepage = "https://github.com/decalage2/oletools";
    license = with licenses; [ bsd2 /* and */ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
