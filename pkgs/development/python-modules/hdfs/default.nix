{ buildPythonPackage
, docopt
, fastavro
, fetchFromGitHub
, lib
, nose
, pytestCheckHook
, requests
, six
}:

buildPythonPackage rec {
  pname = "hdfs";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "mtth";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-KXJDQEc4+T9r8sB41SOgcx8Gth3qAOZceoOpsLbJ+ak=";
  };

  propagatedBuildInputs = [ docopt requests six ];

  nativeCheckInputs = [ fastavro nose pytestCheckHook ];

  pythonImportsCheck = [ "hdfs" ];

  meta = with lib; {
    description = "Python API and command line interface for HDFS";
    homepage = "https://github.com/mtth/hdfs";
    changelog = "https://github.com/mtth/hdfs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
