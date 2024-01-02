{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylgnetcast";
  version = "0.3.8";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Drafteed";
    repo = "python-lgnetcast";
    rev = "refs/tags/v${version}";
    hash = "sha256-UxZ4XM7n0Ryd4D967fXPTA4sqTrZwS8Tj/Q8kNGdk8Q=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pylgnetcast"
  ];

  meta = with lib; {
    description = "Python API client for the LG Smart TV running NetCast 3 or 4";
    homepage = "https://github.com/Drafteed/python-lgnetcast";
    changelog = "https://github.com/Drafteed/python-lgnetcast/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
