{ lib
, buildPythonPackage
, fetchFromGitHub
, docopt
, requests
# Test inputs
, pytestCheckHook
, nose
}:

buildPythonPackage rec {
  pname = "hdfs";
  version = "2.5.8";

  # Some test files missing on PyPi
  src = fetchFromGitHub {
    owner = "mtth";
    repo = "hdfs";
    rev = version;
    sha256 = "1ma04i42fn3szlvw9rdijjh697b4apxb3bqsp7z2dm0p98hkg17p";
  };

  propagatedBuildInputs = [
    docopt
    requests
  ];

  pythonImportsCheck = [ "hdfs" ];
  checkInputs = [ pytestCheckHook nose ];

  meta = with lib; {
    description = "API and command line interface for HDFS";
    homepage = "https://hdfscli.readthedocs.io/en/latest/";
    changelog = "https://github.com/mtth/hdfs/blob/master/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
