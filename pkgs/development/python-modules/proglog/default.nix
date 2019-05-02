{ stdenv, fetchPypi, buildPythonPackage, tqdm }:

buildPythonPackage rec {
  pname = "proglog";
  version = "0.1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13diln950wk6nnn4rpmzx37rvrnpa7f803gwygiwbq1q46zwri6q";
  };

  propagatedBuildInputs = [ tqdm ];

  meta = with stdenv.lib; {
    description = "Logs and progress bars manager for Python";
    homepage = https://github.com/Edinburgh-Genome-Foundry/Proglog;
    license = licenses.mit;
  };
}
