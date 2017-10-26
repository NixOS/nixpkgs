{ stdenv, buildPythonPackage, fetchPypi, pkgs, pkgconfig, chardet, lxml }:

buildPythonPackage rec {
  pname = "html5-parser";
  version = "0.4.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b9f3a1d4cdb8742e8e4ecafab04bff541bde4ff09af233293ed0b94028ec1ab5";
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
