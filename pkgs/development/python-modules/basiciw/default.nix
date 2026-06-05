{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  gcc,
  wirelesstools,
  isPyPy,
}:

buildPythonPackage rec {
  pname = "basiciw";
  version = "0.2.2";
  pyproject = true;

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ajmflvvlkflrcmqmkrx0zaira84z8kv4ssb2jprfwvjh8vfkysb";
  };

  build-system = [ setuptools ];

  buildInputs = [ gcc ];
  dependencies = [ wirelesstools ];

  meta = {
    description = "Get info about wireless interfaces using libiw";
    homepage = "https://github.com/enkore/basiciw";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
  };
}
