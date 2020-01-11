{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  version = "0.12.0";
  pname = "pyfribidi";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "64726a4a56783acdc79c6b9b3a15f16e6071077c897a0b999f3b43f744bc621c";
  };

  meta = with stdenv.lib; {
    description = "A simple wrapper around fribidi";
    homepage = https://github.com/pediapress/pyfribidi;
    license = stdenv.lib.licenses.gpl2;
  };

}
