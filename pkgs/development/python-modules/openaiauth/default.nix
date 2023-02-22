{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "openaiauth";
  version = "0.3.2";

  src = fetchPypi {
    inherit version;
    pname = "OpenAIAuth";
    hash = "sha256-CPcBgGvxRO677EdPI3lNtJXkCW7el6N6N2GeaDo5ApU=";
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
