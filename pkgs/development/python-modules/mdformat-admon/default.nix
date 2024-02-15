{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, mdformat
, mdit-py-plugins
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdformat-admon";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = "mdformat-admon";
    rev = "v${version}";
    hash = "sha256-33Q3Re/axnoOHZ9XYA32mmK+efsSelJXW8sD7C1M/jU=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    mdformat
    mdit-py-plugins
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Mdformat plugin for admonitions";
    homepage = "https://github.com/KyleKing/mdformat-admon";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
