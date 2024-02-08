{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, mdformat
, mdit-py-plugins
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdformat-admon";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
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

  meta = with lib; {
    description = "Mdformat plugin for admonitions";
    homepage = "https://github.com/KyleKing/mdformat-admon";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
