{ lib, buildPythonPackage, fetchPypi, pkgs, pkg-config, chardet, lxml }:

buildPythonPackage rec {
  pname = "html5-parser";
  version = "0.4.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9294418c0da95c2d5facc19d3dc32941093a6b8e3b3e4b36cc7b5a1697fbca4";
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ chardet lxml pkgs.libxml2 ];

  doCheck = false; # No such file or directory: 'run_tests.py'

  meta = with lib; {
    description = "Fast C based HTML 5 parsing for python";
    homepage = "https://html5-parser.readthedocs.io";
    license = licenses.asl20;
  };
}
