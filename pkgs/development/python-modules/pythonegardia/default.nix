{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "pythonegardia";
  version = "1.0.52";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "jeroenterheerdt";
    repo = "python-egardia";
    tag = "v${version}";
    sha256 = "sha256-lQ/7tH74MllwFe2kF5OcYSb4rQd+yJU1W6ztG4Z6Y0U=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests, only two test file for manual interaction
  doCheck = false;

  pythonImportsCheck = [ "pythonegardia" ];

  meta = {
    description = "Python interface with Egardia/Woonveilig alarms";
    homepage = "https://github.com/jeroenterheerdt/python-egardia";
    changelog = "https://github.com/jeroenterheerdt/python-egardia/releases/tag/v${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
