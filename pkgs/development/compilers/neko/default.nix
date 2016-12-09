{ stdenv, fetchurl, fetchpatch, boehmgc, zlib, sqlite, pcre, cmake, pkgconfig
, git, apacheHttpd, apr, aprutil, mariadb, mbedtls, openssl, pkgs, gtk2
}:

stdenv.mkDerivation rec {
  name = "neko-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "http://nekovm.org/media/neko-${version}-src.tar.gz";
    sha256 = "15ng9ad0jspnhj38csli1pvsv3nxm75f0nlps7i10194jvzdb4qc";
  };

  buildInputs =
    [ boehmgc zlib sqlite pcre cmake pkgconfig git apacheHttpd apr aprutil
      mariadb.client mbedtls openssl ]
      ++ stdenv.lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.Security
                                                pkgs.darwin.apple_sdk.frameworks.Carbon]
      ++ stdenv.lib.optional stdenv.isLinux gtk2;

  prePatch = ''
    sed -i -e '/allocated = strdup/s|"[^"]*"|"'"$out/lib/neko:$out/bin"'"|' vm/load.c
  '';

  checkPhase = ''
    bin/neko bin/test.n
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "A high-level dynamically typed programming language";
    homepage = http://nekovm.org;
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

