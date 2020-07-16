{ lib
, buildPythonPackage
, fetchPypi
, traitlets
, jupyter_core
, pyzmq
, dateutil
, isPyPy
, py
, tornado
}:

buildPythonPackage rec {
  pname = "jupyter_client";
  version = "6.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5099cda1ac86b27b655a715c51e15bdc8bd9595b2b17adb41a2bd446bbbafc4a";
  };

  propagatedBuildInputs = [
    traitlets
    jupyter_core
    pyzmq
    dateutil
    tornado
  ] ++ lib.optional isPyPy py;

  # Circular dependency with ipykernel
  doCheck = false;

  meta = {
    description = "Jupyter protocol implementation and client libraries";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
