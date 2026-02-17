{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "http-sfv";
  version = "0.9.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mnot";
    repo = "http_sfv";
    rev = "http_sfv-${version}";
    hash = "sha256-xf9bGDfsEcQnFQ2b1bLRGYug+H4e5jeV/LJstQtp6Bw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ typing-extensions ];

  # Tests require external data (https://github.com/httpwg/structured-field-tests)
  doCheck = false;

  pythonImportsCheck = [ "http_sfv" ];

  meta = {
    description = "Module to parse and serialise HTTP structured field values";
    homepage = "https://github.com/mnot/http_sfv";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
