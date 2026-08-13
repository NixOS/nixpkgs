{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dash-table";
  version = "5.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "dash_table";
    inherit version;
    hash = "sha256-GGJNaT1MjvLd7Jmm8WdZNDen6gvxU6og8xjBcMW8cwg=";
  };

  build-system = [ setuptools ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "First-Class Interactive DataTable for Dash";
    homepage = "https://dash.plot.ly/datatable";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
