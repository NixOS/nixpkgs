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
    sha256 = "4923f4d1e78be15f19f03a608fb34ba9cb71bf5205de3c9fe7461c49078167a7";
  };

  propagatedBuildInputs = [ pillow ];

  meta = with lib; {
    description = "Eases the transition from PIL to Pillow for Python packages";
    homepage = "https://github.com/beanbaginc/pillowfight";
    license = licenses.mit;
  };
}
