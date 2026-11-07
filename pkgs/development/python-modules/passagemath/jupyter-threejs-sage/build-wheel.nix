{
  fetchPypi,
  buildPythonPackage,
}:
buildPythonPackage {
  pname = "jupyter-threejs-sage";
  version = "130";
  format = "wheel";

  src = fetchPypi {
    pname = "jupyter_threejs_sage";
    version = "130";
    format = "wheel";
    dist = "py3";
    python = "py3";
    abi = "none";
    platform = "any";
    hash = "sha256-3MYYAjo3UUWYU3rpPugr3NhxDMTfj6B0b1HbxRM1blI=";
  };

  pythonImportsCheck = [ "jupyter_threejs_sage" ];
}
