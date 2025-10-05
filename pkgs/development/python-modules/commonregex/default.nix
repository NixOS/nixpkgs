{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "commonregex";
  version = "1.5.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JxUwZ4rYr1PA6MIzp2JZeWnoRtACnxIhWsF4eR894KU=";
  };

  build-system = [ setuptools ];

  meta = with lib; {
    description = "Collection of common regular expressions bundled with an easy to use interface";
    homepage = "https://github.com/madisonmay/CommonRegex";
    maintainers = with maintainers; [ k900 ];
    license = licenses.mit;
  };
}
