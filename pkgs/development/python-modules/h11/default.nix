{ lib, buildPythonPackage, fetchPypi, fetchpatch, pytest }:

buildPythonPackage rec {
  pname = "h11";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qfad70h59hya21vrzz8dqyyaiqhac0anl2dx3s3k80gpskvrm1k";
  };

  checkInputs = [ pytest ];

  patches = [
    # This fixes a broken test case in 0.9.0 with newer versions of pytest,
    # when this package version is bumped to >0.9.0 it can likely be dropped.
    # https://github.com/python-hyper/h11/issues/86
    ( fetchpatch {
      url = "https://github.com/python-hyper/h11/commit/cc0c63ed9b67f4ee71f087406008be3443712f6c.patch";
      sha256 = "05ff4fp89xl62ip16w7f4dcw0grvkwyq5d8wzlknsahbxy5f7a8h";
    })
  ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Pure-Python, bring-your-own-I/O implementation of HTTP/1.1";
    license = licenses.mit;
  };
}
