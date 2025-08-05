{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  paho-mqtt,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyephember2";
  version = "2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roberty99";
    repo = "pyephember2";
    tag = "Release${version}";
    hash = "sha256-BxDXjrXPx6UNWo7mGLzbIGtenE0B10x39iCUCzGFAr0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    paho-mqtt
    requests
  ];

  pythonImportsCheck = [ "pyephember2" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/roberty99/pyephember2/releases/tag/${src.tag}";
    description = "Python library to work with ember from EPH Controls";
    homepage = "https://github.com/ttroy50/pyephember";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
