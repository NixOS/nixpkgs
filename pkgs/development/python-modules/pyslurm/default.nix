{ lib, fetchFromGitHub, buildPythonPackage, cython, slurm }:

buildPythonPackage rec {
  pname = "pyslurm";
  version = "20180427";

  src = fetchFromGitHub {
    repo = "pyslurm";
    owner = "PySlurm";
    rev = "3900e1afac9ffd13c80c57d8c39933d42eb7bad7";
    sha256 = "1a183ig4sdbc70rx2yyaslyq61wkbsf8cbim1jj0kzrp65nf0vls";
  };

  buildInputs = [ cython slurm ];
  setupPyBuildFlags = [ "--slurm-lib=${slurm}/lib" "--slurm-inc=${slurm.dev}/include" ];

  meta = with lib; {
    homepage = https://github.com/PySlurm/pyslurm;
    description = "Python bindings to Slurm";
    license = licenses.gpl2;
    maintainers = [ maintainers.veprbl ];
  };
}
