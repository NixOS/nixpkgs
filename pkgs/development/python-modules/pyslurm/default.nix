{ lib, fetchFromGitHub, buildPythonPackage, cython, slurm }:

buildPythonPackage rec {
  pname = "pyslurm";
  version = "18-08-3";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    rev = version;
    sha256 = "1rymx106xa99wd4n44s7jw0w41spg39y1ji4fgn01yk7wjfrdrwg";
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
