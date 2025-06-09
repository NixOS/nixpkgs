{
  lib,
  argcomplete,
  buildPythonPackage,
  fetchPypi,
  gql,
  pythonOlder,
  pyyaml,
  requests-toolbelt,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-gitlab";
  version = "5.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "python_gitlab";
    inherit version;
    hash = "sha256-vFMei6PlZBtgQJRF1JGazmiiwYyw7G1I+87WYWuVQWY=";
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

  meta = with lib; {
    description = "Interact with GitLab API";
    homepage = "https://github.com/python-gitlab/python-gitlab";
    changelog = "https://github.com/python-gitlab/python-gitlab/blob/v${version}/CHANGELOG.md";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ nyanloutre ];
    mainProgram = "gitlab";
  };
}
