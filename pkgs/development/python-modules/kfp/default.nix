{ stdenv, buildPythonPackage, fetchPypi, kfp-server-api, pyyaml, kubernetes, strip-hints, jsonschema
, requests-toolbelt, cloudpickle, deprecated, click, tabulate, google_cloud_storage }:

buildPythonPackage rec {
  pname = "kfp";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dnlh156gcwai2q9vfda91dpcn07d6lwmayal8xvpnm4j4hdr1gy";
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
