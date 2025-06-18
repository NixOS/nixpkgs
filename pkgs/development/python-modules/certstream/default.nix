{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  termcolor,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "certstream";
  version = "1.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5pLWXqlEel22zRRsWWmvZDTt2HFj/gsQCWK7XX0iPds=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    termcolor
    websocket-client
  ];

  pythonImportsCheck = [
    "certstream"
  ];

  meta = {
    description = "CertStream is a library for receiving certificate transparency list updates in real time";
    homepage = "https://pypi.org/project/certstream/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
  };
}
