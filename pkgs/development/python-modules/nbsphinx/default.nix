{ lib
, buildPythonPackage
, fetchPypi
, docutils
, jinja2
, nbconvert
, nbformat
, sphinx
, traitlets
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nbsphinx";
<<<<<<< HEAD
  version = "0.9.3";
=======
  version = "0.8.12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-7DOchpG2iPhnYQSjZ6S4zz6gH9CJ3CjSTewi1WOxFWI=";
=======
    hash = "sha256-dlcEFs3svrIdv1w9aqIEztbB3X6+9Ad7XCG4xuzpUz8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    docutils
    jinja2
    nbconvert
    nbformat
    sphinx
    traitlets
  ];

  # The package has not tests
  doCheck = false;

  JUPYTER_PATH = "${nbconvert}/share/jupyter";

  pythonImportsCheck = [
    "nbsphinx"
  ];

  meta = with lib; {
    description = "Jupyter Notebook Tools for Sphinx";
    homepage = "https://nbsphinx.readthedocs.io/";
    changelog = "https://github.com/spatialaudio/nbsphinx/blob/${version}/NEWS.rst";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
