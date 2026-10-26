{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  beautifulsoup4,
  html5lib,
  requests,
  fusepy,
}:

buildPythonPackage (finalAttrs: {
  pname = "htmllistparse";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-bcimvwPIQ7nTJYQ6JqI1GnlbVzzZKiybgnFiEBnGQII=";
  };

  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [
    beautifulsoup4
    html5lib
    requests
    fusepy
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "htmllistparse" ];

  meta = {
    homepage = "https://github.com/gumblex/htmllisting-parser";
    description = "Python parser for Apache/nginx-style HTML directory listing";
    mainProgram = "rehttpfs";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
