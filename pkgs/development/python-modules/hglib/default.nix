{ stdenv, buildPythonPackage, fetchPypi, substituteAll, python, nose, mercurial }:

buildPythonPackage rec {
  pname = "python-hglib";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c1fa0cb4d332dd6ec8409b04787ceba4623e97fb378656f7cab0b996c6ca3b2";
  };

  patches = [
    (substituteAll {
      src = ./hgpath.patch;
      hg = "${mercurial}/bin/hg";
    })
  ];

  checkInputs = [ nose ];

  checkPhase = ''
    ${python.interpreter} test.py --with-hg "${mercurial}/bin/hg"
  '';

  meta = with stdenv.lib; {
    description = "Mercurial Python library";
    homepage = "http://selenic.com/repo/python-hglib";
    license = licenses.mit;
    maintainers = with maintainers; [ dfoxfranke ];
    platforms = platforms.all;
  };
}
