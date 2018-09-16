{ lib, buildPythonPackage, fetchPypi, nose, pkgconfig }:

buildPythonPackage rec {
  pname = "pkgconfig";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "048c3b457da7b6f686b647ab10bf09e2250e4c50acfe6f215398a8b5e6fcdb52";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [ pkgconfig ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "Interface Python with pkg-config";
    homepage = https://github.com/matze/pkgconfig;
    license = licenses.mit;
  };
}
