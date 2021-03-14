{ lib, stdenv, fetchurl, boehmgc, zlib, sqlite, pcre, cmake, pkg-config
, git, apacheHttpd, apr, aprutil, libmysqlclient, mbedtls, openssl, pkgs, gtk2, libpthreadstubs
}:

stdenv.mkDerivation rec {
  pname = "neko";
  version = "2.2.0";

  src = fetchurl {
    url = "https://nekovm.org/media/neko-${version}-src.tar.gz";
    sha256 = "1qv47zaa0vzhjlq5wb71627n7dbsxpc1gqpg0hsngjxnbnh1q46g";
  };

  nativeBuildInputs = [ cmake pkg-config git ];
  buildInputs =
    [ boehmgc zlib sqlite pcre apacheHttpd apr aprutil
      libmysqlclient mbedtls openssl libpthreadstubs ]
      ++ lib.optional stdenv.isLinux gtk2
      ++ lib.optionals stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.Security
                                                pkgs.darwin.apple_sdk.frameworks.Carbon];
  cmakeFlags = [ "-DRUN_LDCONFIG=OFF" ];

  installCheckPhase = ''
    bin/neko bin/test.n
  '';

  doInstallCheck = true;
  dontPatchELF = true;
  dontStrip = true;

  meta = with lib; {
    description = "A high-level dynamically typed programming language";
    homepage = "https://nekovm.org";
    license = licenses.lgpl21;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
