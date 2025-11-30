{
  lib,
  bleak-retry-connector,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "avea";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "k0rventen";
    repo = "avea";
    tag = "v${version}";
    hash = "sha256-IfD74nsuHYBrwXebpRE9tzPIwp+i3jdZjh49gz8NRz4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "avea" ];

  meta = with lib; {
    description = "Python module for interacting with Elgato's Avea bulb";
    homepage = "https://github.com/k0rventen/avea";
    changelog = "https://github.com/k0rventen/avea/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
