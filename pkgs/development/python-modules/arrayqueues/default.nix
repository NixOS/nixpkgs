{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  numpy,
}:

buildPythonPackage rec {
  pname = "arrayqueues";
  version = "1.4.1";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7I+5BQO/gsvTREDkBfxrMblw3JPfY48S4KI4PCGPtFY=";
  };

  propagatedBuildInputs = [ numpy ];

  meta = {
    homepage = "https://github.com/portugueslab/arrayqueues";
    description = "Multiprocessing queues for numpy arrays using shared memory";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
