{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "colorama";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d";
  };

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/tartley/colorama;
    license = licenses.bsd3;
    description = "Cross-platform colored terminal text";
  };
}

