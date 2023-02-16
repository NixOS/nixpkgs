{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "arnparse";
  version = "0.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PokaInc";
    repo = "arnparse";
    rev = version;
    sha256 = "sha256-2+wxzYoS/KJXjYM6lZguxbr2Oxobo0eFNnzWZHLi0WM=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "arnparse"
  ];

  meta = with lib; {
    description = "Parse ARNs using Python";
    homepage = "https://github.com/PokaInc/arnparse";
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
