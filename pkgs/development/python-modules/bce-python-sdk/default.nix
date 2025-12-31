{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchPypi,
  setuptools,
  future,
  pycryptodome,
  six,
  nix-update-script,
}:

let
  version = "0.9.57";
in
buildPythonPackage {
  pname = "bce-python-sdk";
  inherit version;
  pyproject = true;

  disabled = pythonAtLeast "3.13";

  src = fetchPypi {
    pname = "bce_python_sdk";
    inherit version;
    hash = "sha256-797kmORvaBg/W31BnPgFJLzsLAzWHe+ABdNYtP7PQ4E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    future
    pycryptodome
    six
  ];

  pythonImportsCheck = [ "baidubce" ];

  passthru.updateScript = nix-update-script { attrPath = "python312Packages.bce-python-sdk"; };

  meta = {
    description = "Baidu Cloud Engine SDK for python";
    homepage = "https://github.com/baidubce/bce-sdk-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kyehn ];
  };
}
