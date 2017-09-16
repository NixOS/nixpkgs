{ stdenv, buildPythonPackage, fetchPypi, nose, mercurial, isPy3k }:

buildPythonPackage rec {
  pname = "python-hglib";
  version = "2.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qll9cc9ndqizby00gxdcf6d0cysdhjkr8670a4ffrk55bcnwgb9";
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
