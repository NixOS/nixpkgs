{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "nlpcloud";
<<<<<<< HEAD
  version = "1.1.44";
=======
  version = "1.0.41";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-dOW/M9FJJiCii4+lZJ6Pg2bAdSpul4JRtzYdI7VgJbM=";
=======
    hash = "sha256-LtwN1fF/lfvXrB30P0VvuVGnsG8p1ZAalDCYL/a9uGE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "nlpcloud"
  ];

  meta = with lib; {
    description = "Python client for the NLP Cloud API";
    homepage = "https://nlpcloud.com/";
    changelog = "https://github.com/nlpcloud/nlpcloud-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
