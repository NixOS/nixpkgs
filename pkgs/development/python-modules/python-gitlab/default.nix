{
  lib,
  argcomplete,
  buildPythonPackage,
  fetchPypi,
  gql,
  pyyaml,
  requests-toolbelt,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-gitlab";
  version = "8.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_gitlab";
    inherit version;
    hash = "sha256-Zg8V4/iJ7EMHl9JgMivGHZD42QrM/BC6N1k7Ea7Tcb0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    requests-toolbelt
  ];

  optional-dependencies = {
    autocompletion = [ argcomplete ];
    graphql = [ gql ] ++ gql.optional-dependencies.httpx;
    yaml = [ pyyaml ];
  };

  # Tests rely on a gitlab instance on a local docker setup
  doCheck = false;

  pythonImportsCheck = [ "gitlab" ];

  meta = {
    description = "Interact with GitLab API";
    homepage = "https://github.com/python-gitlab/python-gitlab";
    changelog = "https://github.com/python-gitlab/python-gitlab/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ nyanloutre ];
    mainProgram = "gitlab";
  };
}
