{ buildPythonPackage, fetchPypi, setuptools, python3Packages, lib }:

buildPythonPackage rec {
  pname = "revChatGPT";
  version = "3.1.0";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jC5/M0ni9oHXOFvH7mLhW7qAnA9tcSWH9P+ptfqsU/w=";
  };

  buildInputs = [ setuptools ];

  propagatedBuildInputs = with python3Packages; [
    openaiauth
    requests
    httpx
  ];

  meta = with lib; {
    description = "A conversational chatbot built using GPT models from Hugging Face Transformers.";
    homepage = "https://github.com/realsnick/revchatgpt";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
  };
}
