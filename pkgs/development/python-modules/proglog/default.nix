{ lib, fetchPypi, buildPythonPackage, tqdm }:

buildPythonPackage rec {
  pname = "proglog";
  version = "0.1.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZYwoycguTK6y8l9Ij/+c6s4i+NabFdDByG1kJ15N2rQ=";
  };

  propagatedBuildInputs = [ tqdm ];

  meta = with lib; {
    description = "Logs and progress bars manager for Python";
    homepage = "https://github.com/Edinburgh-Genome-Foundry/Proglog";
    license = licenses.mit;
  };
}
