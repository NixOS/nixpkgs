{ lib, stdenv, fetchurl, perl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "libxcrypt";
  version = "4.4.28";

  src = fetchurl {
    url = "https://github.com/besser82/libxcrypt/releases/download/v${version}/libxcrypt-${version}.tar.xz";
    sha256 = "sha256-npNoEfn60R28ozyhm9l8VcUus8oVkB8nreBGzHnmnoc=";
  };

  outputs = [
    "out"
    "man"
  ];

  configureFlags = [
    "--enable-hashes=all"
    "--enable-obsolete-api=glibc"
    "--disable-failure-tokens"
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    "--disable-werror"
  ];

  nativeBuildInputs = [
    perl
  ];

  enableParallelBuilding = true;

  doCheck = !stdenv.hostPlatform.isMusl;

  passthru.tests = {
    inherit (nixosTests) login shadow;
  };

  meta = with lib; {
    description = "Extended crypt library for descrypt, md5crypt, bcrypt, and others";
    homepage = "https://github.com/besser82/libxcrypt/";
    platforms = platforms.all;
    maintainers = with maintainers; [ dottedmag hexa ];
    license = licenses.lgpl21Plus;
  };
}
