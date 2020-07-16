{ stdenv, buildPythonPackage, fetchPypi, six, urllib3, python-dateutil }:

buildPythonPackage rec {
  pname = "kfp-server-api";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d1rm3azjhksh21ilifndlbkli4255w7flykyrsw317yswdg2cmn";
  };

  propagatedBuildInputs = [ six urllib3 python-dateutil ];

  meta = with stdenv.lib; {
    homepage = https://github.com/kubeflow/pipelines;
    description = "Generated python client for the KF Pipelines server API";
    license = licenses.asl20;
  };
}
