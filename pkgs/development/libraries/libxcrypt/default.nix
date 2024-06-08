{ lib, stdenv, fetchurl, perl
# Update the enabled crypt scheme ids in passthru when the enabled hashes change
, enableHashes ? "strong"
, nixosTests
, runCommand
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxcrypt";
  version = "4.4.36";

  src = fetchurl {
    url = "https://github.com/besser82/libxcrypt/releases/download/v${finalAttrs.version}/libxcrypt-${finalAttrs.version}.tar.xz";
    hash = "sha256-5eH0yu4KAd4q7ibjE4gH1tPKK45nKHlm0f79ZeH9iUM=";
  };

  outputs = [
    "out"
    "man"
  ];

  configureFlags = [
    "--enable-hashes=${enableHashes}"
    "--enable-obsolete-api=glibc"
    "--disable-failure-tokens"
    # required for musl, android, march=native
    "--disable-werror"
  ];

  makeFlags = let
    lld17Plus = stdenv.cc.bintools.isLLVM
      && lib.versionAtLeast stdenv.cc.bintools.version "17";
  in []
    # fixes: can't build x86_64-w64-mingw32 shared library unless -no-undefined is specified
    ++ lib.optionals stdenv.hostPlatform.isWindows [ "LDFLAGS+=-no-undefined" ]

    # lld 17 sets `--no-undefined-version` by default and `libxcrypt`'s
    # version script unconditionally lists legacy compatibility symbols, even
    # when not exported: https://github.com/besser82/libxcrypt/issues/181
    ++ lib.optionals lld17Plus [ "LDFLAGS+=-Wl,--undefined-version" ]
  ;

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
