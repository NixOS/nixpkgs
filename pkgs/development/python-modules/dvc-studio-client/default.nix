{
  lib,
  buildPythonPackage,
  dulwich,
  fetchFromGitHub,
  gitpython,
  pythonOlder,
  requests,
  setuptools-scm,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "dvc-studio-client";
  version = "0.22.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "dvc-studio-client";
    tag = version;
    hash = "sha256-pMjLbtsUD0fj4OcJI8FufQRYe7HJ0S8z1jYK0Ri7uWA=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    dulwich
    gitpython
    requests
    voluptuous
  ];

  pythonImportsCheck = [ "dvc_studio_client" ];

  # Tests try to access network
  doCheck = false;

  meta = with lib; {
    description = "Library to post data from DVC/DVCLive to Iterative Studio";
    homepage = "https://github.com/iterative/dvc-studio-client";
    changelog = "https://github.com/iterative/dvc-studio-client/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
