{ buildPythonPackage
, docopt
, fastavro
, fetchFromGitHub
, lib
, nose
, pytestCheckHook
, pythonOlder
, requests
, six
}:

buildPythonPackage rec {
  pname = "hdfs";
  version = "2.5.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtth";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-94Q3IUoX1Cb+uRqvsfpVZJ1koJSx5cQ3/XpYJ0gkQNU=";
  };

  propagatedBuildInputs = [ docopt requests six ];

  nativeCheckInputs = [ fastavro nose pytestCheckHook ];

  pythonImportsCheck = [ "hdfs" ];

  meta = with lib; {
    description = "Python API and command line interface for HDFS";
    homepage = "https://github.com/mtth/hdfs";
    changelog = "https://github.com/mtth/hdfs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
