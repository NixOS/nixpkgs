{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pynacl,
  requests,
}:

buildPythonPackage rec {
  pname = "pynuki";
  version = "1.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = "pynuki";
    tag = version;
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

  meta = {
    description = "Python bindings for nuki.io bridges";
    homepage = "https://github.com/pschmitt/pynuki";
    changelog = "https://github.com/pschmitt/pynuki/releases/tag/${version}";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
