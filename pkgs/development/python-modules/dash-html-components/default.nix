{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dash-html-components";
  version = "2.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "dash_html_components";
    inherit (finalAttrs) version;
    hash = "sha256-hwOmAQgPAmGaY5CZjgs9pKXaq+l6H9epzrwJ0BXyblA=";
  };

  build-system = [ setuptools ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "HTML components for Dash";
    homepage = "https://dash.plot.ly/dash-html-components";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
