{
  lib,
  requests,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "aladdin-connect";
  version = "0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "shoejosh";
    repo = "aladdin-connect";
    tag = version;
    hash = "sha256-kLvMpSGa5WyDOH3ejAJyFGsB9IiMXp+nvVxM/ZkxyFw=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aladdin_connect" ];

  meta = {
    description = "Python library for interacting with Genie Aladdin Connect devices";
    homepage = "https://github.com/shoejosh/aladdin-connect";
    changelog = "https://github.com/shoejosh/aladdin-connect/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
