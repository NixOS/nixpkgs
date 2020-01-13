{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "publicsuffix";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22ce1d65ab6af5e9b2122e2443facdb93fb5c4abf24138099cb10fe7989f43b6";
  };


  # disable test_fetch and the doctests (which also invoke fetch)
  postPatch = ''
    sed -i -e "/def test_fetch/i\\
    \\t@unittest.skip('requires internet')" -e "/def additional_tests():/,+1d" tests.py
  '';

  meta = with stdenv.lib; {
    description = "Allows to get the public suffix of a domain name";
    homepage = "https://pypi.python.org/pypi/publicsuffix/";
    license = licenses.mit;
  };
}
