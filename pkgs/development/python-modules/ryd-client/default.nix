{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
}:
buildPythonPackage rec {
  pname = "ryd-client";
  version = "0.0.6";
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PxrVdVw+dAkF8WWzYyg2/B5CFurNPA5XRNtH9uu/SiY=";
  };

  build-system = [ setuptools ];
  dependencies = [ requests ];

  meta = {
    description = "Python client library for the Return YouTube Dislike API ";
    homepage = "https://github.com/bbilly1/ryd-client";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
