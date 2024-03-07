{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, mdformat
, mdit-py-plugins
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mdformat-simple-breaks";
  version = "0.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "csala";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4lJHB4r9lI2uGJ/BmFFc92sumTRKBBwiRmGBdQkzfd0=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  buildInputs = [
    mdformat
  ];

  pythonImportsCheck = [
    "mdformat_simple_breaks"
  ];

  meta = with lib; {
    description = "mdformat plugin to render thematic breaks using three dashes";
    homepage = "https://github.com/csala/mdformat-simple-breaks";
    license = licenses.mit;
    maintainers = with maintainers; [ aldoborrero ];
  };
}
