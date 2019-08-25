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
  version = "5.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "102qgc7isfxwq0zsj6m9apcyj2hk8c8c4fz7656lxlpmvxgazs4q";
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
    homepage = https://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
