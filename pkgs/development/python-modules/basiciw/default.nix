{
  lib,
  buildPythonPackage,
  fetchPypi,
  gcc,
  wirelesstools,
  isPy27,
  isPyPy,
}:

buildPythonPackage rec {
  pname = "basiciw";
  version = "0.2.2";
  format = "setuptools";

  disabled = isPy27 || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ajmflvvlkflrcmqmkrx0zaira84z8kv4ssb2jprfwvjh8vfkysb";
  };

  buildInputs = [ gcc ];
  propagatedBuildInputs = [ wirelesstools ];

  meta = {
    description = "Get info about wireless interfaces using libiw";
    homepage = "https://github.com/enkore/basiciw";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
  };
}
