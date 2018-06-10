{ stdenv, buildPythonPackage, fetchPypi, pkgs, pkgconfig, chardet, lxml }:

buildPythonPackage rec {
  pname = "html5-parser";
  version = "0.4.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01mx33sx4dhl4kj6wc48nj6jz7ry60rkhjv0s6k8h5xmjf5yy0x9";
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
