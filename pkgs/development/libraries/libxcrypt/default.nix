{ lib, stdenv, fetchurl, perl
# Update the enabled crypt scheme ids in passthru when the enabled hashes change
, enableHashes ? "strong"
, nixosTests
<<<<<<< HEAD
, runCommand
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxcrypt";
  version = "4.4.36";

  src = fetchurl {
    url = "https://github.com/besser82/libxcrypt/releases/download/v${finalAttrs.version}/libxcrypt-${finalAttrs.version}.tar.xz";
    hash = "sha256-5eH0yu4KAd4q7ibjE4gH1tPKK45nKHlm0f79ZeH9iUM=";
=======
}:

stdenv.mkDerivation rec {
  pname = "libxcrypt";
  version = "4.4.33";

  src = fetchurl {
    url = "https://github.com/besser82/libxcrypt/releases/download/v${version}/libxcrypt-${version}.tar.xz";
    hash = "sha256-6HrPnGUsVzpHE9VYIVn5jzBdVu1fdUzmT1fUGU1rOm8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [
    "out"
    "man"
  ];

  configureFlags = [
    "--enable-hashes=${enableHashes}"
    "--enable-obsolete-api=glibc"
    "--disable-failure-tokens"
<<<<<<< HEAD
    # required for musl, android, march=native
    "--disable-werror"
  ];

  # fixes: can't build x86_64-w64-mingw32 shared library unless -no-undefined is specified
  makeFlags = lib.optionals stdenv.hostPlatform.isWindows [ "LDFLAGS=-no-undefined"] ;

=======
  ] ++ lib.optionals (stdenv.hostPlatform.isMusl || stdenv.hostPlatform.libc == "bionic") [
    "--disable-werror"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    perl
  ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    tests = {
      inherit (nixosTests) login shadow;
<<<<<<< HEAD

      passthruMatches = runCommand "libxcrypt-test-passthru-matches" { } ''
        ${python3.interpreter} "${./check_passthru_matches.py}" ${lib.escapeShellArgs ([ finalAttrs.src enableHashes "--" ] ++ finalAttrs.passthru.enabledCryptSchemeIds)}
        touch "$out"
      '';
    };
    enabledCryptSchemeIds = [
      # https://github.com/besser82/libxcrypt/blob/v4.4.35/lib/hashes.conf
=======
    };
    enabledCryptSchemeIds = [
      # https://github.com/besser82/libxcrypt/blob/v4.4.33/lib/hashes.conf
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/besser82/libxcrypt/blob/v${finalAttrs.version}/NEWS";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Extended crypt library for descrypt, md5crypt, bcrypt, and others";
    homepage = "https://github.com/besser82/libxcrypt/";
    platforms = platforms.all;
    maintainers = with maintainers; [ dottedmag hexa ];
    license = licenses.lgpl21Plus;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
