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
  version = "6.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5724827aedb1948ed6ed15131372bc304a8d3ad9ac67ac19da7c95120d6b17e0";
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
