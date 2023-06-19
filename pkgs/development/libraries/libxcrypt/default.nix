{ lib, stdenv, fetchurl, perl
# Update the enabled crypt scheme ids in passthru when the enabled hashes change
, enableHashes ? "strong"
, nixosTests
, runCommand
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxcrypt";
  version = "4.4.35";

  src = fetchurl {
    url = "https://github.com/besser82/libxcrypt/releases/download/v${finalAttrs.version}/libxcrypt-${finalAttrs.version}.tar.xz";
    hash = "sha256-qMk1UFtV8d8NF/i/1ZRox8Zwmh0xgxsPjj4EWrj9RV0=";
  };

  outputs = [
    "out"
    "man"
  ];

  configureFlags = [
    "--enable-hashes=${enableHashes}"
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

  passthru = {
    tests = {
      inherit (nixosTests) login shadow;

      passthruMatches = runCommand "libxcrypt-test-passthru-matches" { } ''
        ${python3.interpreter} "${./check_passthru_matches.py}" ${lib.escapeShellArgs ([ finalAttrs.src enableHashes "--" ] ++ finalAttrs.passthru.enabledCryptSchemeIds)}
        touch "$out"
      '';
    };
    enabledCryptSchemeIds = [
      # https://github.com/besser82/libxcrypt/blob/v4.4.35/lib/hashes.conf
      "y"   # yescrypt
      "gy"  # gost_yescrypt
      "7"   # scrypt
      "2b"  # bcrypt
      "2y"  # bcrypt_y
      "2a"  # bcrypt_a
      "6"   # sha512crypt
    ];
  };

  meta = with lib; {
    changelog = "https://github.com/besser82/libxcrypt/blob/v${finalAttrs.version}/NEWS";
    description = "Extended crypt library for descrypt, md5crypt, bcrypt, and others";
    homepage = "https://github.com/besser82/libxcrypt/";
    platforms = platforms.all;
    maintainers = with maintainers; [ dottedmag hexa ];
    license = licenses.lgpl21Plus;
  };
})
