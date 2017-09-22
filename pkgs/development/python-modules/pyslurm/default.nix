{ lib, fetchFromGitHub, buildPythonPackage, cython, slurm }:

buildPythonPackage rec {
  name = "pyslurm";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    rev = "69e4f4fd66003b98ddb7da25613fe641d4ae160d";
    sha256 = "051kafkndbniklxyf0drb360aiblnqcf9rqjbvmqh66zrfya1m28";
  };

  patches = [ ./pyslurm-dlfcn.patch ];

  buildInputs = [ cython slurm ];
  setupPyBuildFlags = [ "--slurm-lib=${slurm}/lib" "--slurm-inc=${slurm.dev}/include" ];

  meta = with lib; {
    homepage = https://github.com/PySlurm/pyslurm;
    description = "Python bindings to Slurm";
    license = licenses.gpl2;
    maintainers = [ maintainers.veprbl ];
  };
}
