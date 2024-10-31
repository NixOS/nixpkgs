{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pynacl,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pynuki";
  version = "1.6.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "pynuki";
    rev = "refs/tags/${version}";
    hash = "sha256-PF5FmAuPcJXq8gQ8HyzdtL2HiiUjueT+LAS1lYRvrwM=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pynacl
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynuki" ];

  meta = with lib; {
    description = "Python bindings for nuki.io bridges";
    homepage = "https://github.com/pschmitt/pynuki";
    changelog = "https://github.com/pschmitt/pynuki/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
