{ lib
, buildPythonPackage
, fetchPypi
, dash
}:

buildPythonPackage rec {
  pname = "dash-bootstrap-components";
  version = "1.1.0";

  buildInputs = [
    dash
  ];

  # Strange test failure:
  # TypeError: calling <class 'dash_bootstrap_components._components.CardImg.CardImg'> returned CardImg(None), not a test
  doCheck = false;

  pythonImportsCheck = [
    "dash_bootstrap_components"
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NAdV08pNLlsnRfxnOYeF5nMJL67yCX4olfhYCxrRgW4=";
  };

  meta = with lib; {
    description = "Library of Bootstrap components for use with Plotly Dash";
    longDescription = ''
      dash-bootstrap-components is a library of Bootstrap components for use with Plotly Dash,
      that makes it easier to build consistently styled Dash apps with complex, responsive layouts.
    '';
    homepage = "https://github.com/facultyai/dash-bootstrap-components";
    changelog = "https://raw.githubusercontent.com/owncloud/pyocclient/master/docs/source/CHANGES.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ neosimsim turion ];
  };
}
