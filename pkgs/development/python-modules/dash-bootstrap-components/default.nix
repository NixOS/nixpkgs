{
  lib,
  buildPythonPackage,
  fetchPypi,
  dash,
  hatchling,
}:

buildPythonPackage rec {
  pname = "dash-bootstrap-components";
  version = "2.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "dash_bootstrap_components";
    hash = "sha256-wyBsCSN3S7xqbdqngiuNmqUyaw08HnzXlcyXUCX+JIQ=";
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
