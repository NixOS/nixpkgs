{
  lib,
  buildPythonPackage,
  fetchPypi,

  setuptools,

  six,
  requests,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "feedfinder2";
  version = "0.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NwHuAabIX4uGWgScMLoLRgiFjIA/6OMNHSif2+idDv4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    six
    requests
    beautifulsoup4
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "feedfinder2" ];

  meta = with lib; {
    description = "A Python library for finding feed links on websites";
    homepage = "https://github.com/dfm/feedfinder2";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
