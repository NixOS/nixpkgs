{ buildPythonPackage, fetchPypi, isPy27, setuptools_scm, nose, six, importlib-metadata, toml }:

buildPythonPackage rec {
  pname = "inflect";
  version = "5.0.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d284c905414fe37c050734c8600fe170adfb98ba40f72fc66fed393f5b8d5ea0";
  };

  nativeBuildInputs = [ setuptools_scm toml ];
  propagatedBuildInputs = [ six importlib-metadata ];
  checkInputs = [ nose ];
}
