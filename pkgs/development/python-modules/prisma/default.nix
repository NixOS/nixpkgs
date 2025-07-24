{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  httpx,
  jinja2,
  nodeenv,
  pydantic,
  python-dotenv,
  pythonOlder,
  setuptools,
  strenum,
  tomlkit,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "prisma";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "RobertCraigie";
    repo = "prisma-client-py";
    tag = "v${version}";
    hash = "sha256-F+Up1HHslralt3NvZZ/wT+CKvzKOjhEEuMEeT0L6NZM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    httpx
    jinja2
    nodeenv
    pydantic
    python-dotenv
    tomlkit
    typing-extensions
  ]
  ++ lib.optionals (pythonOlder "3.11") [ strenum ];

  # Building the client requires network access
  doCheck = false;

  pythonImportsCheck = [ "prisma" ];

  meta = with lib; {
    description = "Auto-generated and fully type-safe database client for prisma";
    homepage = "https://github.com/RobertCraigie/prisma-client-py";
    changelog = "https://github.com/RobertCraigie/prisma-client-py/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
