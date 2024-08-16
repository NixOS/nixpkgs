{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyrympro";
  version = "0.0.8";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "OnFreund";
    repo = "pyrympro";
    rev = "refs/tags/v${version}";
    hash = "sha256-mRvKLPgtBgmFDTHqra7GslxsgsJpQ2w/DE0Zgz5jujk=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyrympro" ];

  meta = with lib; {
    description = "Module to interact with Read Your Meter Pro";
    homepage = "https://github.com/OnFreund/pyrympro";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
