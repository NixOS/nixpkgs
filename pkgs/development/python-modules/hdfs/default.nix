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
  # See https://github.com/mtth/hdfs/issues/176.
  version = "2.5.8";

  src = fetchFromGitHub {
    owner = "mtth";
    repo = pname;
    rev = version;
    hash = "sha256-94Q3IUoX1Cb+uRqvsfpVZJ1koJSx5cQ3/XpYJ0gkQNU=";
  };

  propagatedBuildInputs = [ docopt requests six ];

  nativeCheckInputs = [ fastavro nose pytestCheckHook ];

  pythonImportsCheck = [ "hdfs" ];

  meta = with lib; {
    description = "Python API and command line interface for HDFS";
    homepage = "https://github.com/mtth/hdfs";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
