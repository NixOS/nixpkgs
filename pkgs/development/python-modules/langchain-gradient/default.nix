{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  langchain-core,
  python-digitalocean,
  langchain-tests,
  gradient,
  python-dotenv,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-gradient";
  version = "0.1.22";
  pyproject = true;

  # GH doesn't have any tags unfortunately
  src = fetchPypi {
    inherit version;
    pname = "langchain_gradient";
    hash = "sha256-JnKqGmvJ0dPttjS0Kgn/lPc8al4cwK3pOerx/ELfgCo=";
  };

  pythonRemoveDeps = [ "c63a5cfe-b235-4fbe-8bbb-82a9e02a482a-python" ];

  pythonRelaxDeps = [ "gradient" ];

  build-system = [ poetry-core ];

  dependencies = [
    langchain-core
    python-digitalocean
    langchain-tests
    python-dotenv
    gradient
  ];

  # marshmallow.exceptions.StringNotCollectionError: "only" should be a collection of strings.
  # Support for marshmallow > 3
  # pythonImportsCheck = [ "langchain_gradient" ];

  # all tests require networking + a valid API key
  doCheck = false;

  meta = {
    description = "Langchain Gradient Integration";
    homepage = "https://github.com/digitalocean/langchain-gradient";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
}
