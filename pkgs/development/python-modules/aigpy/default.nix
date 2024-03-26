{ lib
, buildPythonPackage
, fetchPypi
, mutagen
, requests
, colorama
, prettytable
, pycrypto
, pydub
}:

buildPythonPackage rec {
  pname = "aigpy";
  version = "2022.7.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1kQced6YdC/wvegqFVhZfej4+4aemGXvKysKjejP13w=";
  };

  propagatedBuildInputs = [ mutagen requests colorama prettytable pycrypto pydub ];

  meta = {
    homepage = "https://github.com/AIGMix/AIGPY";
    description = "A python library with miscellaneous tools";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.misterio77 ];
    platforms = lib.platforms.all;
  };
}
