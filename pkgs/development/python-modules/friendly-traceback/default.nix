{
  lib,
  buildPythonPackage,
  fetchPypi,
  asttokens,
  executing,
  pure-eval,
  stack-data,
  setuptools,
  six,
}:
buildPythonPackage rec {
  pname = "friendly-traceback";
  version = "0.7.61";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jKFJ6k7/oRSp1DVAeNAlLbxT4pHNzGPyPjS4+2W6FfM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asttokens
    executing
    pure-eval
    stack-data
    six
  ];

  doCheck = false;
  pythonImportsCheck = [ "friendly_traceback" ];

  meta = {
    description = "Friendlier Python tracebacks";
    homepage = "https://github.com/friendly-traceback/friendly-traceback";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bendlas ];
  };
}
