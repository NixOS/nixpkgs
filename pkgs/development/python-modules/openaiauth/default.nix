{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "openaiauth";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "OpenAIAuth";
    hash = "sha256-wmVR+cN/uJ75l62uzmHqpvEcnjzi6CU0kQ2e/5LxkBw=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "OpenAIAuth"
  ];

  meta = with lib; {
    description = "Library for authenticating with the OpenAI API";
    homepage = "https://github.com/acheong08/OpenAIAuth";
    changelog = "https://github.com/acheong08/OpenAIAuth/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
  };
}
