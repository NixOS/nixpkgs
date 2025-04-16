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
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "dash_bootstrap_components";
    hash = "sha256-cRIwo164ZmS1wFUqkdFZ9LRz2EEs9bSPNF+7ARjq35E=";
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
