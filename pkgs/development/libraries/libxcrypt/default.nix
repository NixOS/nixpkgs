{ lib, stdenv, fetchurl, perl, nixosTests }:

stdenv.mkDerivation rec {
  pname = "libxcrypt";
  version = "4.4.33";

  src = fetchurl {
    url = "https://github.com/besser82/libxcrypt/releases/download/v${version}/libxcrypt-${version}.tar.xz";
    hash = "sha256-6HrPnGUsVzpHE9VYIVn5jzBdVu1fdUzmT1fUGU1rOm8=";
  };

  outputs = [
    "out"
    "man"
  ];

  configureFlags = [
    "--enable-hashes=all"
    "--enable-obsolete-api=glibc"
    "--disable-failure-tokens"
  ] ++ lib.optionals (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.libc == "bionic") [
    "--disable-werror"
  ];

  nativeBuildInputs = [
    perl
  ];

  enableParallelBuilding = true;

  doCheck = true;

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
