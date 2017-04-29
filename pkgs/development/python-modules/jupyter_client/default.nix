{ lib
, buildPythonPackage
, fetchPypi
, nose
, traitlets
, jupyter_core
, pyzmq
, dateutil
, isPyPy
, py
}:

buildPythonPackage rec {
  pname = "jupyter_client";
  version = "5.0.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fe573880b5ca4469ed0bece098f4b910c373d349e12525e1ea3566f5a14536b";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [traitlets jupyter_core pyzmq dateutil] ++ lib.optional isPyPy py;

  checkPhase = ''
    nosetests -v
  '';

  # Circular dependency with ipykernel
  doCheck = false;

  meta = {
    description = "Jupyter protocol implementation and client libraries";
    homepage = http://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}