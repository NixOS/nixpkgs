{ lib
, buildPythonPackage
, fetchPypi
, dash
}:

buildPythonPackage rec {
  pname = "dash-bootstrap-components";
  version = "1.3.0";

  src = fetchPypi {
    pname = "dash-bootstrap-components";
    inherit version;
    sha256 = "sha256-8S8pn9yRlDxw15UElJNlpiL9nKWihLU1lC31zEecE1Q=";
  };

  propagatedBuildInputs = [ dash ];

  # No tests in archive
  doCheck = false;
  pythonImportsCheck = [ "dash_bootstrap_components" ];

  meta = with lib; {
    description = "dash-bootstrap-components is a library of Bootstrap components for use with Plotly Dash";
    homepage = "https://dash-bootstrap-components.opensource.faculty.ai/";
    license = licenses.asl20;
    maintainers = [ maintainers.mschneider ];
  };
}
