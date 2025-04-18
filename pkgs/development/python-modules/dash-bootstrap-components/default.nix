{
  lib,
  buildPythonPackage,
  fetchPypi,
  dash,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dash-bootstrap-components";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "dash_bootstrap_components";
    hash = "sha256-PMZYbzfLP8wEvHLTgBwHt5IEAGaizHjSMwiFUpJl7Cg=";
  };

  build-system = [ hatchling ];

  dependencies = [ dash ];

  # Tests a additional requirements
  doCheck = false;

  pythonImportsCheck = [ "dash_bootstrap_components" ];

  meta = with lib; {
    description = "Bootstrap components for Plotly Dash";
    homepage = "https://github.com/facultyai/dash-bootstrap-components";
    changelog = "https://github.com/facultyai/dash-bootstrap-components/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
