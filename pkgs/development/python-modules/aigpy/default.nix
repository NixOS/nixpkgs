{
  lib,
  buildPythonPackage,
  fetchPypi,
  mutagen,
  requests,
  colorama,
  prettytable,
  pycrypto,
  pydub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aigpy";
  version = "2022.7.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1kQced6YdC/wvegqFVhZfej4+4aemGXvKysKjejP13w=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    mutagen
    requests
    colorama
    prettytable
    pycrypto
    pydub
  ];

  meta = {
    homepage = "https://github.com/AIGMix/AIGPY";
    description = "Python library with miscellaneous tools";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.misterio77 ];
    platforms = lib.platforms.all;
  };
}
