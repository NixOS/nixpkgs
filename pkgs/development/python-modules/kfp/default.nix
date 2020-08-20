{ stdenv, buildPythonPackage, fetchPypi, kfp-server-api, pyyaml, kubernetes, strip-hints, jsonschema
, requests-toolbelt, cloudpickle, deprecated, click, tabulate, google_cloud_storage }:

buildPythonPackage rec {
  pname = "kfp";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "184f90gajkljfw8i5f6spmz7ifzrb40z2dkgmwk0s3cij1bza9r9";
  };

  propagatedBuildInputs = [
      kfp-server-api
      pyyaml
      kubernetes
      strip-hints
      jsonschema
      requests-toolbelt
      cloudpickle
      deprecated
      click
      tabulate
      google_cloud_storage
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/kubeflow/pipelines;
    description = "KubeFlow Pipelines SDK";
    license = licenses.asl20;
  };
}
