{ lib, buildPythonPackage, fetchPypi, pkgs, pkg-config, chardet, lxml }:

buildPythonPackage rec {
  pname = "html5-parser";
  version = "0.4.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25fe8f6848cbc15187f6748c0695df32bcf1b37df6420b6a01b4ebe1ec1ed48f";
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
