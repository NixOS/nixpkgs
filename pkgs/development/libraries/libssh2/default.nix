{ stdenv, fetchurl, openssl, zlib, windows }:

stdenv.mkDerivation rec {
  name = "libssh2-1.8.0";

  src = fetchurl {
    url = "${meta.homepage}/download/${name}.tar.gz";
    sha256 = "1m3n8spv79qhjq4yi0wgly5s5rc8783jb1pyra9bkx1md0plxwrr";
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
