{ lib
, blockdiag
, buildPythonPackage
, fetchFromGitHub
, nose
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "actdiag";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "blockdiag";
    repo = pname;
    rev = version;
    hash = "sha256-WmprkHOgvlsOIg8H77P7fzEqxGnj6xaL7Df7urRkg3o=";
  };

  propagatedBuildInputs = [
    blockdiag
    setuptools
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/actdiag/tests/"
  ];

  pythonImportsCheck = [
    "actdiag"
  ];

  meta = with lib; {
    description = "Generate activity-diagram image from spec-text file (similar to Graphviz)";
    homepage = "http://blockdiag.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor SuperSandro2000 ];
  };
}
