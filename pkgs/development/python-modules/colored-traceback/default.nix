{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pygments,
}:

buildPythonPackage rec {
  pname = "colored-traceback";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7LyOQfBxLqgZMdfNQ2uL658+/xWV0kmPGD4O9ptW/oQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ pygments ];

  # No setuptools tests for the package.
  doCheck = false;

  pythonImportsCheck = [ "colored_traceback" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/staticshock/colored-traceback.py";
    description = "Automatically color Python's uncaught exception tracebacks";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ pamplemousse ];
=======
  meta = with lib; {
    homepage = "https://github.com/staticshock/colored-traceback.py";
    description = "Automatically color Python's uncaught exception tracebacks";
    license = licenses.isc;
    maintainers = with maintainers; [ pamplemousse ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
