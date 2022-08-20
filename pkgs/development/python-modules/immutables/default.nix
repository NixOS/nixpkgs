{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, mypy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "immutables";
  version = "0.18";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "MagicStack";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lXCoPTcpTOv9K0xCVjbrP3qlzP9tfk/e3Rk3oOmbS/Y=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  checkInputs = [
    mypy
    pytestCheckHook
  ];

  disabledTests = [
    # Version mismatch
    "testMypyImmu"
  ];

  pythonImportsCheck = [
    "immutables"
  ];

  meta = with lib; {
    description = "An immutable mapping type";
    homepage = "https://github.com/MagicStack/immutables";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ catern ];
  };
}
