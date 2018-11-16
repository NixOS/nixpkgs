{ stdenv, buildPythonPackage, fetchPypi, nose, mercurial, isPy3k }:

buildPythonPackage rec {
  pname = "python-hglib";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c1fa0cb4d332dd6ec8409b04787ceba4623e97fb378656f7cab0b996c6ca3b2";
  };

  checkInputs = [ nose ];
  buildInputs = [ mercurial ];

  checkPhase = ''python test.py'';
  doCheck = if isPy3k then false else true;

  meta = with stdenv.lib; {
    description = "Mercurial Python library";
    homepage = "http://selenic.com/repo/python-hglib";
    license = licenses.mit;
    maintainers = with maintainers; [ dfoxfranke ];
    platforms = platforms.all;
  };
}
