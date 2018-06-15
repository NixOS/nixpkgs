{ stdenv, fetchurl, boehmgc, zlib, sqlite, pcre, cmake, pkgconfig
, git, apacheHttpd, apr, aprutil, mysql, mbedtls, openssl, pkgs, gtk2, libpthreadstubs
}:

stdenv.mkDerivation rec {
  name = "neko-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "https://nekovm.org/media/neko-${version}-src.tar.gz";
    sha256 = "1qv47zaa0vzhjlq5wb71627n7dbsxpc1gqpg0hsngjxnbnh1q46g";
  };

  nativeBuildInputs = [ cmake pkgconfig git ];
  buildInputs =
    [ boehmgc zlib sqlite pcre apacheHttpd apr aprutil
      mysql.connector-c mbedtls openssl libpthreadstubs ]
      ++ stdenv.lib.optional stdenv.isLinux gtk2
      ++ stdenv.lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.Security
                                                pkgs.darwin.apple_sdk.frameworks.Carbon];
  cmakeFlags = [ "-DRUN_LDCONFIG=OFF" ];

  installCheckPhase = ''
    bin/neko bin/test.n
  '';

  doInstallCheck = true;
  dontPatchELF = true;
  dontStrip = true;

  meta = with stdenv.lib; {
    description = "A high-level dynamically typed programming language";
    homepage = http://nekovm.org;
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
