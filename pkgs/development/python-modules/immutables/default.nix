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
  version = "0.16";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "MagicStack";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f6nlpvrs41cjrnikx48qd0rlf7d89h6dzlr5zcndzsim7fgsmgz";
  };

  propagatedBuildInputs = [
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

  pythonImportsCheck = [ "immutables" ];

  meta = with lib; {
    description = "An immutable mapping type for Python";
    homepage = "https://github.com/MagicStack/immutables";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ catern ];
  };
}
