{ lib
, buildPythonPackage
, fetchPypi
, traitlets
, jupyter_core
, pyzmq
, dateutil
, isPyPy
, py
, ipykernel
, ipython
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "jupyter_client";
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca30cf1786047925ebacd6f6faa3a993efaa004b584f7d83bc8b807f7cd3f6bb";
  };

  checkInputs = [ ipykernel ipython mock pytest ];
  propagatedBuildInputs = [traitlets jupyter_core pyzmq dateutil] ++ lib.optional isPyPy py;

  checkPhase = ''
    py.test
  '';

  patches = [
    ./wheel_workaround.patch
  ];

  # Circular dependency with ipykernel
  doCheck = false;

  meta = {
    description = "Jupyter protocol implementation and client libraries";
    homepage = http://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}