{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "logging-journald";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-lR2bRtw9kUY/22ij5Ge79nY4hzEq9zRl+GhFPZHW/0E=";
  };

  # Circular dependency with aiomisc
  doCheck = false;

  pythonImportsCheck = [
    "logging_journald"
  ];

  meta = with lib; {
    description = "Logging handler for writing logs to the journald";
    homepage = "https://github.com/mosquito/logging-journald";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
