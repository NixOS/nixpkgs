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
  version = "5.1.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08756b021765c97bc5665390700a4255c2df31666ead8bff116b368d09912aba";
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