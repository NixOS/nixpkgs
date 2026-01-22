{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tapsaff";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q3VLbPsgXAYvZsjcW1m3lus2SFMjNJ8AmkcNK0THB6I=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
  ];

  # Package does not have tests
  doCheck = false;

  pythonImportsCheck = [
    "tapsaff"
  ];

  meta = {
    description = "Provides an API for requesting information from taps-aff.co.uk";
    homepage = "https://github.com/bazwilliams/python-taps-aff";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
