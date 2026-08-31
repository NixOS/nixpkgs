{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  pytestCheckHook,
  asttokens,
  executing,
  pure-eval,
  stack-data,
  six,
}:

buildPythonPackage rec {
  pname = "friendly-traceback";
  version = "0.7.61";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jKFJ6k7/oRSp1DVAeNAlLbxT4pHNzGPyPjS4+2W6FfM=";
  };

  propagatedBuildInputs = [
    asttokens
    executing
    pure-eval
    stack-data
    six
  ];

  doCheck = false;

  meta = {
    description = "Friendlier Python tracebacks";
    homepage = "https://github.com/friendly-traceback/friendly-traceback";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bendlas ];
  };
}
