{
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "intel-extension-for-pytorch";
  version = "2.7.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version;
    hash = "";
  };
}
