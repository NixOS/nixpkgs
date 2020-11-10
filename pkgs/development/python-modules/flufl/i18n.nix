{ buildPythonPackage, fetchPypi, atpublic }:

buildPythonPackage rec {
  pname = "flufl.i18n";
  version = "2.0.2";

  propagatedBuildInputs = [ atpublic ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "1csgds59nx0ann9v2alqr69lakp1cnc1ikmbgn96l6n23js7c2ah";
  };
}
