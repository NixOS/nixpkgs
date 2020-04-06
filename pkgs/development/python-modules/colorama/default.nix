{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "colorama";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1";
  };

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/tartley/colorama;
    license = licenses.bsd3;
    description = "Cross-platform colored terminal text";
  };
}

