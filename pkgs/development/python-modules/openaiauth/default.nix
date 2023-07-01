{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "openaiauth";
  version = "2.0.0";

  src = fetchPypi {
    inherit version;
    pname = "OpenAIAuth";
    hash = "sha256-wmVR+cN/uJ75l62uzmHqpvEcnjzi6CU0kQ2e/5LxkBw=";
  };

  propagatedBuildInputs = [ requests ];

  doCheck = false;

  pythonImportsCheck = [
    "OpenAIAuth"
  ];

  meta = with lib; {
    description = "A Python library for authenticating with the OpenAI API";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
    homepage = "https://github.com/acheong08/OpenAIAuth";
    changelog = "https://github.com/acheong08/OpenAIAuth/releases/tag/${version}";
  };
}
