{
  lib,
  blinker,
  buildPythonPackage,
  fetchPypi,
  flask,
  pythonOlder,
  setuptools,
  webob,
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "4.8.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m9YA/PauhWe20RZSJknqFzUXqpizc56bpzsf6ivIJEQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ webob ];

  optional-dependencies = {
    flask = [
      blinker
      flask
    ];
  };

  pythonImportsCheck = [ "bugsnag" ];

  # Module ha no tests
  doCheck = false;

  meta = with lib; {
    description = "Automatic error monitoring for Python applications";
    homepage = "https://github.com/bugsnag/bugsnag-python";
    changelog = "https://github.com/bugsnag/bugsnag-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
