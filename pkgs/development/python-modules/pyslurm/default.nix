{ lib, fetchFromGitHub, buildPythonPackage, cython, slurm }:

buildPythonPackage rec {
  pname = "pyslurm";
  version = "20180811";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    rev = "2d4f0553de971309b7e465d4d64528b8a5fafb05";
    sha256 = "1cy57gyvvmzx0c8fx4h6p8dgan0ay6pdivdf24k1xiancjnw20xr";
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
