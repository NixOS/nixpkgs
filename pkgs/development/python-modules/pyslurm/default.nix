{ lib, fetchFromGitHub, fetchpatch, buildPythonPackage, cython, slurm }:

buildPythonPackage rec {
  pname = "pyslurm";
  version = "19-05-0";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    rev = version;
    sha256 = "1lfb4q81y96syz5an1lzscfcvmfvlkf4cfl3i5zllw9r3gbarl2r";
  };

  buildInputs = [ cython slurm ];
  setupPyBuildFlags = [ "--slurm-lib=${slurm}/lib" "--slurm-inc=${slurm.dev}/include" ];

  # Test cases need /etc/slurm/slurm.conf and require a working slurm installation
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/PySlurm/pyslurm;
    description = "Python bindings to Slurm";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bhipple ];
  };
}
