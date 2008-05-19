{ fetchurl, stdenv, zlib, lzo, libgcrypt
, guileBindings, guile }:

assert guileBindings -> guile != null;

stdenv.mkDerivation rec {

  name = "gnutls-2.2.4";

  src = fetchurl {
    url = "mirror://gnu/gnutls/${name}.tar.bz2";
    sha256 = "1k140912g78mvadr1ga0nm2qibdbb6llp2l60m35bwr90b5abz7x";
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
