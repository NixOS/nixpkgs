{ lib, pkgs, buildPythonPackage, fetchPypi, isPy3k
, numpy
}:

buildPythonPackage rec {
  pname = "arrayqueues";
  version = "1.2.0b0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gvrxb2rw0dk469wq5azylar7hhanfp07gl5mc6ajdbgz9gsd6ln";
  };

  propagatedBuildInputs = [
    numpy
  ];

  meta = {
    homepage = "https://github.com/portugueslab/arrayqueues";
    description = "Multiprocessing queues for numpy arrays using shared memory";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
