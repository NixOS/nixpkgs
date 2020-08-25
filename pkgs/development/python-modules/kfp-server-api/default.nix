{ stdenv, buildPythonPackage, fetchPypi, six, urllib3, python-dateutil }:

buildPythonPackage rec {
  pname = "kfp-server-api";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14h3na1a8ansdlf1gjhbhabh58y14vfpqn60cjr3744rbk7z6kg7";
  };

  propagatedBuildInputs = [ six urllib3 python-dateutil ];

  meta = with stdenv.lib; {
    homepage = https://github.com/kubeflow/pipelines;
    description = "Generated python client for the KF Pipelines server API";
    license = licenses.asl20;
  };
}
