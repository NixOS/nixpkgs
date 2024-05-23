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
    sha256 = "3af4b0441090ee65bd6dde930d29f93f50c4a2fe6048e2a9d288285f5e4dc441";
  };

  pythonNamespaces = [ "jaraco" ];

  doCheck = false;
  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ six ];
}
