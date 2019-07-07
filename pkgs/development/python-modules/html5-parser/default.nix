{ stdenv, buildPythonPackage, fetchPypi, pkgs, pkgconfig, chardet, lxml }:

buildPythonPackage rec {
  pname = "html5-parser";
  version = "0.4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gzs9fa38m80y509fg58ylwhxgy7w28ww968pi6wmfrih9ib6l93";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ chardet lxml pkgs.libxml2 ];

  doCheck = false; # No such file or directory: 'run_tests.py'

  meta = with stdenv.lib; {
    description = "Fast C based HTML 5 parsing for python";
    homepage = https://html5-parser.readthedocs.io;
    license = licenses.asl20;
  };
}
