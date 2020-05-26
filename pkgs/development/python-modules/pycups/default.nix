{ stdenv, lib, buildPythonPackage, fetchurl, cups, libiconv }:

buildPythonPackage rec {
  pname = "pycups";
  version = "1.9.73";

  src = fetchurl {
    url = "http://cyberelk.net/tim/data/pycups/pycups-${version}.tar.bz2";
    sha256 = "c381be011889ca6f728598578c89c8ac9f7ab1e95b614474df9f2fa831ae5335";
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
