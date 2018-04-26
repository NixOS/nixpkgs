{ lib, buildPythonPackage, fetchPypi, nose, pkgconfig }:

buildPythonPackage rec {
  pname = "pkgconfig";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "107x2wmchlch8saixb488cgjz9n6inl38wi7nxkb942rbaapxiqb";
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
