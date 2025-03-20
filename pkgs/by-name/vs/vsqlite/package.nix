{
  lib,
  stdenv,
  fetchurl,
  boost,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "vsqlite";
  version = "0.3.13";

  src = fetchurl {
    url = "https://evilissimo.fedorapeople.org/releases/vsqlite--/0.3.13/vsqlite++-${version}.tar.gz";
    sha256 = "17fkj0d2jh0xkjpcayhs1xvbnh1d69f026i7vs1zqnbiwbkpz237";
  };

  buildInputs = [
    boost
    sqlite
  ];

  prePatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile.in \
        --replace '-Wl,--as-needed' "" \
        --replace '-Wl,-soname -Wl,libvsqlitepp.so.3' \
                  "-Wl,-install_name,$out/lib/libvsqlitepp.3.dylib"
  '';

  meta = with lib; {
    homepage = "https://vsqlite.virtuosic-bytes.com/";
    description = "C++ wrapper library for sqlite";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
