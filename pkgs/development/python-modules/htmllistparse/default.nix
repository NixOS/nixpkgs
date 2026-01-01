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

buildPythonPackage rec {
  pname = "htmllistparse";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/gumblex/htmllisting-parser";
    description = "Python parser for Apache/nginx-style HTML directory listing";
    mainProgram = "rehttpfs";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/gumblex/htmllisting-parser";
    description = "Python parser for Apache/nginx-style HTML directory listing";
    mainProgram = "rehttpfs";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
