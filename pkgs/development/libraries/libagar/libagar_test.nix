{ stdenv, fetchurl, bsdbuild, libagar, perl, libjpeg, libpng, openssl }:

let srcs = import ./srcs.nix { inherit fetchurl; }; in
stdenv.mkDerivation rec {
  name = "libagar-test-${version}";
  inherit (srcs) version src;

  sourceRoot = "agar-1.5.0/tests";

  preConfigure = ''
    substituteInPlace configure.in \
      --replace '_BSD_SOURCE' '_DEFAULT_SOURCE'
    cat configure.in | ${bsdbuild}/bin/mkconfigure > configure
  '';

  configureFlags = [ "--with-agar=${libagar}" ];

  buildInputs = [ perl bsdbuild libagar libjpeg libpng openssl ];

  meta = with stdenv.lib; {
    description = "Tests for libagar";
    homepage = http://libagar.org/index.html;
    license = with licenses; bsd3;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; linux;
  };
}
