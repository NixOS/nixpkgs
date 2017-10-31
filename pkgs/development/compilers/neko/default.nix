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

  # Patches backported with reference to https://github.com/HaxeFoundation/neko/issues/131
  # They can probably be removed when bumping to next version
  patches = [
    (fetchpatch {
      url = "https://github.com/HaxeFoundation/neko/commit/"
          + "a8c71ad97faaccff6c6e9e09eba2d5efd022f8dc.patch";
      sha256 = "0mnx15cdjs8mnl01mhc9z2gpzh4d1q0ygqnjackrqxz6x235ydyp";
    })
    (fetchpatch {
      url = "https://github.com/HaxeFoundation/neko/commit/"
          + "fe87462d9c7a6ee27e28f5be5e4fc0ac87b34574.patch";
      sha256 = "1jbmq6j32vg3qv20dbh82cp54886lgrh7gkcqins8a2y4l4dl3sc";
    })
    # https://github.com/HaxeFoundation/neko/pull/165
    (fetchpatch {
      url = "https://github.com/HaxeFoundation/neko/commit/"
          + "c6d9c6d796200990b3b6a53a4dc716c9192398e6.patch";
      sha256 = "1pq0qhhb9gbhc3zbgylwp0amhwsz0q0ggpj6v2xgv0hfy7d63rcd";
    })
  ];

  buildInputs =
    [ boehmgc zlib sqlite pcre cmake pkgconfig git apacheHttpd apr aprutil
      mariadb.client mbedtls openssl ]
      ++ stdenv.lib.optional stdenv.isLinux gtk2
      ++ stdenv.lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.Security
                                                pkgs.darwin.apple_sdk.frameworks.Carbon];
  cmakeFlags = [ "-DRUN_LDCONFIG=OFF" ];
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

