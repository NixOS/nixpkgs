{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "colorama";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wd1szk0z3073ghx26ynw43gnc140ibln1safgsis6s6z3s25ss8";
  };

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/tartley/colorama;
    license = licenses.bsd3;
    description = "Cross-platform colored terminal text";
  };
}

