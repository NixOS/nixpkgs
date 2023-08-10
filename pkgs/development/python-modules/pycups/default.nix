{ stdenv, lib, buildPythonPackage, fetchPypi, cups, libiconv }:

buildPythonPackage rec {
  pname = "pycups";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V0NM5fYlSOsSlJyoIX8Gb07rIaXWq4sTRx3ONQ44DJA=";
  };

  buildInputs = [ cups ] ++ lib.optional stdenv.isDarwin libiconv;

  # Wants to connect to CUPS
  doCheck = false;

  meta = with lib; {
    description = "Python bindings for libcups";
    homepage = "http://cyberelk.net/tim/software/pycups/";
    license = with licenses; [ gpl2Plus ];
  };
}
