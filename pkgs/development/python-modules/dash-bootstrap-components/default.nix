{
  lib,
  buildPythonPackage,
  fetchPypi,
  dash,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dash-bootstrap-components";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "dash_bootstrap_components";
    hash = "sha256-lgoeyTl1dHkvSagkECT6POzeD1kwyXGj/IHwFsvrEJU=";
  };

  build-system = [ setuptools ];

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
