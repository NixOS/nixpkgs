{
  lib,
  buildPythonPackage,
  fetchPypi,
  dash,
  hatchling,
}:

buildPythonPackage rec {
  pname = "dash-bootstrap-components";
  version = "2.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "dash_bootstrap_components";
    hash = "sha256-XBYbBKbn7Rmn1U5C8HDCn9bDhdWneX56gpmaovwVsd4=";
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
