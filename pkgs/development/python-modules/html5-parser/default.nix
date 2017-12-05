{ stdenv, buildPythonPackage, fetchPypi, pkgs, pkgconfig, chardet, lxml }:

buildPythonPackage rec {
  pname = "html5-parser";
  version = "0.4.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "173vzg214x7qfq201m4b09wg5nszdgwjw5q02v23k54iqm3kcpnx";
  };

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ chardet lxml pkgs.libxml2 ];

  doCheck = false; # No such file or directory: 'run_tests.py'

  meta = with stdenv.lib; {
    description = "Fast C based HTML 5 parsing for python";
    homepage = https://html5-parser.readthedocs.io;
    license = licenses.asl20;
  };
}
