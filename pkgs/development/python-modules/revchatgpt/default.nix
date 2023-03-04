{ fetchPypi, python3, lib }:

python3.pkgs.buildPythonPackage rec {
  pname = "revChatGPT";
  version = "3.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QBfLVgNzE969+pW6WXqLt6pmCQjqKs8a/5JSokYo4lA=";
  };

  checkPhase = "echo 'No tests'";

  buildInputs = [ python3.pkgs.setuptools ];

  propagatedBuildInputs = with python3.pkgs; [
    openaiauth
    requests
    #    asyncio
    httpx
  ];

  meta = with lib; {
    description = "A conversational chatbot built using GPT models from Hugging Face Transformers.";
    homepage = "https://github.com/realsnick/revchatgpt";
    license = licenses.mit;
    maintainers = with maintainers; [ realsnick ];
  };
}
