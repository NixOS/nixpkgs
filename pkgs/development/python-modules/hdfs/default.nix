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
<<<<<<< HEAD
  version = "2.7.2";
=======
  # See https://github.com/mtth/hdfs/issues/176.
  version = "2.5.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mtth";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-KXJDQEc4+T9r8sB41SOgcx8Gth3qAOZceoOpsLbJ+ak=";
=======
    rev = version;
    hash = "sha256-94Q3IUoX1Cb+uRqvsfpVZJ1koJSx5cQ3/XpYJ0gkQNU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ docopt requests six ];

  nativeCheckInputs = [ fastavro nose pytestCheckHook ];

  pythonImportsCheck = [ "hdfs" ];

  meta = with lib; {
    description = "Python API and command line interface for HDFS";
    homepage = "https://github.com/mtth/hdfs";
<<<<<<< HEAD
    changelog = "https://github.com/mtth/hdfs/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
