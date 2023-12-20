{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "justnimbus";
  version = "0.7.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kvanzuijlen";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-JO8T0JItkkNHxlnDKOO8kM9KSzT7QML4sszPymgXSBA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "justnimbus"
  ];

  meta = with lib; {
    description = "Library for the JustNimbus API";
    homepage = "https://github.com/kvanzuijlen/justnimbus";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}

