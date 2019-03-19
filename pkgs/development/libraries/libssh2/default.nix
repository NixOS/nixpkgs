{ stdenv, fetchurl, openssl, zlib, windows }:

stdenv.mkDerivation rec {
  pname = "libssh2";
  version = "1.8.1";

  src = fetchurl {
    url = "${meta.homepage}/download/${pname}-${version}.tar.gz";
    sha256 = "0ngif3ynk6xqzy5nlfjs7bsmfm81g9f145av0z86kf0vbgrigda0";
  };

  outputs = [ "out" "dev" "devdoc" ];

  buildInputs = [ openssl zlib ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isMinGW windows.mingw_w64;

  meta = with stdenv.lib; {
    description = "A client-side C library implementing the SSH2 protocol";
    homepage = https://www.libssh2.org;
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
