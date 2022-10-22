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
  version = "0.60.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "decalage2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-H3oL8sk2r267wV0hoHOq9r9DY2Atxs+hZUVb6tmHy0w=";
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
    "test_xlm"
  ];

  pythonImportsCheck = [
    "oletools"
  ];

  meta = with lib; {
    description = "Module to analyze MS OLE2 files and MS Office documents";
    homepage = "https://github.com/decalage2/oletools";
    license = with licenses; [ bsd2 /* and */ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
