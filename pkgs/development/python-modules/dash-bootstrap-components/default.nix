{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dash,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dash-bootstrap-components";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "facultyai";
    repo = "dash-bootstrap-components";
    rev = "refs/tags/${version}";
    hash = "sha256-6tx7rOB5FVj44NbTznyZd1Q0HOc8QdxiZOhja5kgpAE=";
  };

  build-system = [ setuptools ];

  dependencies = [ dash ];

  # Tests a additional requirements
  doCheck = false;

  # Circular import
  # pythonImportsCheck = [ "dash_bootstrap_components" ];

  meta = with lib; {
    description = "Bootstrap components for Plotly Dash";
    homepage = "https://github.com/facultyai/dash-bootstrap-components";
    changelog = "https://github.com/facultyai/dash-bootstrap-components/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
