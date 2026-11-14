{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  absl-py,
  aiohttp,
  async-timeout,
  exceptiongroup,
  google-genai,
  ml-collections,
  more-itertools,
  numpy,
  pandas,
  pydantic,
  python-dotenv,
  pyyaml,
  requests,
  tqdm,
  typing-extensions,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "langextract";
  version = "1.0.9";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SUHxYZ8+PfgrOIWDguT3E7b5kvJ1bJIzu7XxsOhyN5c=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    absl-py
    aiohttp
    async-timeout
    more-itertools
    numpy
    pandas
    requests
    tqdm
    typing-extensions
    pydantic
    python-dotenv
    pyyaml
    exceptiongroup
    google-genai
    ml-collections
  ];

  meta = with lib; {
    description = "A library for extracting structured data from language models";
    homepage = "https://github.com/google/langextract";
    license = licenses.asl20;
    maintainers = [ maintainers.keyzox ];
  };
}
