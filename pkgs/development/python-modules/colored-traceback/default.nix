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

  meta = with lib; {
    homepage = "https://github.com/staticshock/colored-traceback.py";
    description = "Automatically color Python's uncaught exception tracebacks";
    license = licenses.isc;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
