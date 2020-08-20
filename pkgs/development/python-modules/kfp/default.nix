{ stdenv, buildPythonPackage, fetchPypi, fetchFromGitHub, kfp-server-api, pyyaml, kubernetes, strip-hints, jsonschema
, requests-toolbelt, cloudpickle, deprecated, click, tabulate, google_cloud_storage, pytestCheckHook }:

buildPythonPackage rec {
  pname = "kfp";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "184f90gajkljfw8i5f6spmz7ifzrb40z2dkgmwk0s3cij1bza9r9";
  };

  #src = fetchFromGitHub {
  #    owner = "kubeflow";
  #    repo = "pipelines";
  #    rev = "1.0.0";
  #    sha256 = "1jlcz5qm6ll6bqiyqcpy32i8m0f5vj3ykhyybzz6c46lzk79cl34";
  #};
  doCheck = false;

  #checkInputs = [
  #    pytestCheckHook
  #];

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
