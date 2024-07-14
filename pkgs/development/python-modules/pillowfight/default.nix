{
  lib,
  buildPythonPackage,
  fetchPypi,
  pillow,
}:

buildPythonPackage rec {
  pname = "pillowfight";
  version = "0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SSP00eeL4V8Z8Dpgj7NLqctxv1IF3jyf50YcSQeBZ6c=";
  };

  propagatedBuildInputs = [ pillow ];

  meta = with lib; {
    description = "Eases the transition from PIL to Pillow for Python packages";
    homepage = "https://github.com/beanbaginc/pillowfight";
    license = licenses.mit;
  };
}
