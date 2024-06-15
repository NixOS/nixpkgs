{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  cups,
  libiconv,
}:

buildPythonPackage rec {
  pname = "pycups";
  version = "2.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hD44XB2/aUmWyoTvAqfzDCg3YDVYj1++rNa64AXPfI0=";
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
