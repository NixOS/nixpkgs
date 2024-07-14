{
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  six,
}:

buildPythonPackage rec {
  pname = "jaraco-stream";
  version = "3.0.3";
  format = "setuptools";

  src = fetchPypi {
    pname = "jaraco.stream";
    inherit version;
    hash = "sha256-OvSwRBCQ7mW9bd6TDSn5P1DEov5gSOKp0ogoX15NxEE=";
  };

  pythonNamespaces = [ "jaraco" ];

  doCheck = false;
  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ six ];
}
