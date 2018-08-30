{ lib, fetchFromGitHub, buildPythonPackage, cython, slurm }:

buildPythonPackage rec {
  pname = "pyslurm";
  version = "20180604";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    rev = "9dd4817e785fee138a9e29c3d71d2ea44898eedc";
    sha256 = "14ivwc27sjnk0z0jpfgyy9bd91m2bhcz11lzp1kk9xn4495i7wvj";
  };

  buildInputs = [ cython slurm ];
  setupPyBuildFlags = [ "--slurm-lib=${slurm}/lib" "--slurm-inc=${slurm.dev}/include" ];

  # Test cases need /etc/slurm/slurm.conf and require a working slurm installation
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/PySlurm/pyslurm;
    description = "Python bindings to Slurm";
    license = licenses.gpl2;
    maintainers = [ maintainers.veprbl ];
  };
}
