{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  setuptools,
  pycryptodome,
  six,
}:

let
  version = "0.9.57";
in
buildPythonPackage {
  pname = "bce-python-sdk";
  inherit version;
  pyproject = true;

  src = fetchPypi {
    pname = "bce_python_sdk";
    inherit version;
    hash = "sha256-797kmORvaBg/W31BnPgFJLzsLAzWHe+ABdNYtP7PQ4E=";
  };

  patches = [
    # From https://github.com/baidubce/bce-sdk-python/pull/15 . Upstream
    # doesn't seem to be responsive, the patch there doesn't apply cleanly on
    # this version, so a vendored patch was produced by running:
    #
    #   git show -- setup.py baidubce
    #
    # in the Git checkout of the PR above.
    ./no-future.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    pycryptodome
    six
  ];

  pythonImportsCheck = [ "baidubce" ];

  meta = {
    description = "Baidu Cloud Engine SDK for python";
    homepage = "https://github.com/baidubce/bce-sdk-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
