{ lib
, beautifulsoup4
, buildPythonPackage
, chardet
, fetchFromGitHub
, lxml
, pkg-config
, pkgs
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "html5-parser";
  version = "0.4.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-l7cCt+zX+qOujS6noc1/p7mELqrHae3eiKQNXBxLm7o=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pkgs.libxml2
  ];

  propagatedBuildInputs = [
    chardet
    lxml
  ];

  nativeCheckInputs = [
    beautifulsoup4
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "html5_parser"
  ];

  pytestFlagsArray = [
    "test/*.py"
  ];

  meta = with lib; {
    description = "Fast C based HTML 5 parsing for python";
    homepage = "https://html5-parser.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
