{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fyta-cli";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dontinelli";
    repo = "fyta_cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-eWuuHIq79n1oFsvBfVySfGCtHz+MlFRR3j8uqtVR+V0=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fyta_cli" ];

  meta = with lib; {
    description = "Module to access the FYTA API";
    homepage = "https://github.com/dontinelli/fyta_cli";
    changelog = "https://github.com/dontinelli/fyta_cli/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
