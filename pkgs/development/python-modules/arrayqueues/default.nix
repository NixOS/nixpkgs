{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, numpy
}:

buildPythonPackage rec {
  pname = "arrayqueues";
  version = "1.3.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
     owner = "portugueslab";
     repo = "arrayqueues";
     rev = "v1.3.1";
     sha256 = "138977clr7yfc5h1p64by0bc6z0xk1dzqmqma2a0y618iizjxzyx";
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
