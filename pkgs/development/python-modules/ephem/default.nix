{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, glibcLocales, pytest }:

buildPythonPackage rec {
  pname = "ephem";
  version = "3.7.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dj4kk325b01s7q1zkwpm9rrzl7n1jf7fr92wcajjhc5kx14hwb0";
  };

  patchFlags = [ "-p0" ];
  checkInputs = [ pytest glibcLocales ];
  # JPLTest uses assets not distributed in package
  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test --pyargs ephem.tests -k "not JPLTest"
  '';

  meta = with stdenv.lib; {
    description = "Compute positions of the planets and stars";
    homepage = https://pypi.python.org/pypi/ephem/;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ chrisrosset ];
  };
}
