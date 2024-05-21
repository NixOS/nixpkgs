{ lib
, buildPythonPackage
, fetchPypi
, pygments
}:

buildPythonPackage rec {
  pname = "colored-traceback";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bafOKx2oafa7VMkntBW5VyfEu22ahMRhXqd9mHKRGwU=";
  };

  buildInputs = [ pygments ];

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
