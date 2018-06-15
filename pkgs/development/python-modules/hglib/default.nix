{ stdenv, buildPythonPackage, fetchPypi, nose, mercurial, isPy3k }:

buildPythonPackage rec {
  pname = "python-hglib";
  version = "2.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fee180bb6796e5d2d25158b2d3c9f048648e427dd28b23a58d369adb14dd67cb";
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
