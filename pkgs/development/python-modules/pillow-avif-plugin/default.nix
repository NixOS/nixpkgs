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
  version = "1.4.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hVz1DQP2/Bbh/V42SzzqC3n0v5DTn/ISOWlzXYUeCLo=";
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
