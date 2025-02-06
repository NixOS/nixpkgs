{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  pydantic,
  requests,
  tqdm,
  typer,
}:

buildPythonPackage rec {
  pname = "python-on-whales";
  version = "0.75.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gabrieldemarmiesse";
    repo = "python-on-whales";
    tag = "v${version}";
    hash = "sha256-JjzBFVgPNnU0q5hL+RZJMs3WxbeZbBKyvsV6clUFjpE=";
  };

  # pythonRuntimeDepsCheck evaluates the more complex expression to 1.10.16 (!) and fails
  configurePhase = ''
    substituteInPlace requirements.txt \
      --replace-fail "pydantic>=2,<3,!=2.0.*" "pydantic>=2.10.0,<3"
  '';

  build-system = [ setuptools ];

  dependencies = [
    pydantic
    requests
    tqdm
    typer
  ];

  doCheck = false; # majority of tests require Docker and/or network access

  pythonImportsCheck = [ "python_on_whales" ];

  meta = with lib; {
    description = "Docker client for Python, designed to be fun and intuitive";
    homepage = "https://github.com/gabrieldemarmiesse/python-on-whales";
    changelog = "https://github.com/gabrieldemarmiesse/python-on-whales/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "python-on-whales";
  };
}
