{ lib
, buildPythonPackage
, fetchFromGitHub
, protobuf
, pycryptodome
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "lakeside";
  version = "0.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nkgilley";
    repo = "python-lakeside";
    rev = "refs/tags/${version}";
    hash = "sha256-Y5g78trkwOF3jsbgTv0uVkvfB1HZN+w1T6xIorxGAhg=";
  };

  propagatedBuildInputs = [
    protobuf
    pycryptodome
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "lakeside"
  ];

  meta = with lib; {
    description = "Library for controlling LED bulbs from Eufy";
    homepage = "https://github.com/nkgilley/python-lakeside";
    changelog = "https://github.com/nkgilley/python-lakeside/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
