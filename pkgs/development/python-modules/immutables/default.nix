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
  version = "0.17";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "MagicStack";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4VuB8eTWHD4hEDj11u/talfv38h2BhogSZmEVyUtnko=";
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
