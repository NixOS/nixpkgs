{ buildPythonPackage, fetchPypi, isPy27, setuptools_scm, nose, six, importlib-metadata, toml }:

buildPythonPackage rec {
  pname = "inflect";
  version = "4.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "def6f3791be9181f0c01e0bf5949304007ec6e04c6674fbef7cc49c657b8a9a5";
  };

  nativeBuildInputs = [ setuptools_scm toml ];
  propagatedBuildInputs = [ six importlib-metadata ];
  checkInputs = [ nose ];
}
