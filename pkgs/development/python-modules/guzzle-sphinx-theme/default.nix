{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sphinx,
}:

buildPythonPackage rec {
  pname = "guzzle-sphinx-theme";
  version = "0.7.11";
  pyproject = true;

  src = fetchPypi {
    pname = "guzzle_sphinx_theme";
    inherit version;
    hash = "sha256-m4wWOcNDwCw/PbffZg3fb1M7VFTukqX3sC7apXP+0+Y=";
  };

  nativeBuildInputs = [ setuptools ];

  doCheck = false; # no tests

  propagatedBuildInputs = [ sphinx ];

  pythonImportsCheck = [ "guzzle_sphinx_theme" ];

<<<<<<< HEAD
  meta = {
    description = "Sphinx theme used by Guzzle: http://guzzlephp.org";
    homepage = "https://github.com/guzzle/guzzle_sphinx_theme/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
=======
  meta = with lib; {
    description = "Sphinx theme used by Guzzle: http://guzzlephp.org";
    homepage = "https://github.com/guzzle/guzzle_sphinx_theme/";
    license = licenses.mit;
    maintainers = with maintainers; [ flokli ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
