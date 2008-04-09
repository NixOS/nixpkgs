{ fetchurl, stdenv, zlib, lzo, libgcrypt
, guileBindings, guile }:

assert guileBindings -> guile != null;

stdenv.mkDerivation rec {

  name = "gnutls-2.3.4";

  src = fetchurl {
    url = "${meta.homepage}/releases/${name}.tar.bz2";
    sha256 = "0n1pq40yl3ali17gkfzd2ad3xb9qrwx67affsqgssqffgmljq63j";
  };

  patches = [ ./tmpdir.patch ];

  configurePhase = ''
    ./configure --prefix="$out" --enable-guile --with-guile-site-dir="$out/share/guile/site"
  '';

  buildInputs = [zlib lzo libgcrypt]
    ++ (if guileBindings then [guile] else []);

  doCheck = true;
  
  meta = {
    description = "The GNU Transport Layer Security Library";
    homepage = http://www.gnu.org/software/gnutls/;
    license = "LGPLv2.1+";
  };
}
