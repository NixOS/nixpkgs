{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
}:

buildPythonPackage rec {
  version = "0.11.0";
  pname = "pyfribidi";
  disabled = isPy3k || isPyPy;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "6f7d83c09eae0cb98a40b85ba3dedc31af4dbff8fc4425f244c1e9f44392fded";
  };

  meta = with stdenv.lib; {
    description = "A simple wrapper around fribidi";
    homepage = https://github.com/pediapress/pyfribidi;
    license = stdenv.lib.licenses.gpl2;
  };

}
