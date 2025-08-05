{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  libavif,
  pillow,
}:

buildPythonPackage rec {
  pname = "pillow-avif-plugin";
  version = "1.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gR4NyL4eRDk9Ljhl7DMKiooRlLlOuM/Kb6d44/R21kk=";
  };

  nativeBuildInputs = [ setuptools ];
  buildInputs = [ libavif ];
  propagatedBuildInputs = [ pillow ];

  meta = {
    description = "Pillow plugin that adds support for AVIF files";
    homepage = "https://github.com/fdintino/pillow-avif-plugin";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ ratcornu ];
  };
}
