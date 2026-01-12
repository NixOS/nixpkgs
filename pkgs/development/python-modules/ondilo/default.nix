{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  oauthlib,
  requests,
  requests-oauthlib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ondilo";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JeromeHXP";
    repo = "ondilo";
    tag = version;
    hash = "sha256-l9pmamJbB/FAqB49S4vQAan9Wgj3qu1J2pboQO1Hg/Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    oauthlib
    requests
    requests-oauthlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "ondilo" ];

  meta = {
    description = "Python package to access Ondilo ICO APIs";
    homepage = "https://github.com/JeromeHXP/ondilo";
    changelog = "https://github.com/JeromeHXP/ondilo/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
