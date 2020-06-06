{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, glibcLocales, pytest }:

buildPythonPackage rec {
  pname = "ephem";
  version = "3.7.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36b51a8dc7cfdeb456dd6b8ab811accab8341b2d562ee3c6f4c86f6d3dbb984e";
  };

  patchFlags = [ "-p0" ];
  checkInputs = [ pytest glibcLocales ];
  # JPLTest uses assets not distributed in package
  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test --pyargs ephem.tests -k "not JPLTest"
  '';

  meta = with stdenv.lib; {
    description = "Compute positions of the planets and stars";
    homepage = "https://pypi.python.org/pypi/ephem/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ chrisrosset ];
  };
}
