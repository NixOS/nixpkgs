{ lib, buildPythonPackage, fetchPypi, isPy3k
, numpy
}:

buildPythonPackage rec {
  pname = "arrayqueues";
  version = "1.3.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a955df768e39d459de28c7ea10ee02f67b1c70996cfa229846ab98df77a6fb69";
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
