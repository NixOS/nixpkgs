{ lib, stdenv, fetchFromGitHub, fetchpatch, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "libargon2";
  version = "20190702";

  src = fetchFromGitHub {
    owner = "P-H-C";
    repo = "phc-winner-argon2";
    rev = version;
    sha256 = "0p4ry9dn0mi9js0byijxdyiwx74p1nr8zj7wjpd1fjgqva4sk23i";
  };

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  patches = [
    # TODO: remove when https://github.com/P-H-C/phc-winner-argon2/pull/277 is merged + released
    (fetchpatch {
      url = "https://github.com/P-H-C/phc-winner-argon2/commit/cd1c1d8d204e4ec4557e358013567c097cb70562.patch";
      sha256 = "0whqv8b6q9602n7vxpzbd8bk8wz22r1jz9x5lrm9z7ib3wz81c8a";
    })
  ];

  makeFlags = [
    "AR=${stdenv.cc.targetPrefix}ar" # Fix cross-compilation
    "PREFIX=${placeholder "out"}"
    "ARGON2_VERSION=${version}"
    "LIBRARY_REL=lib"
    "PKGCONFIG_REL=lib"
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [
    "LIBRARIES=$(LIB_ST)"
  ];

  meta = with lib; {
    description = "A key derivation function that was selected as the winner of the Password Hashing Competition in July 2015";
    longDescription = ''
      A password-hashing function created by by Alex Biryukov, Daniel Dinu, and
      Dmitry Khovratovich. Argon2 was declared the winner of the Password
      Hashing Competition (PHC). There were 24 submissions and 9 finalists.
      Catena, Lyra2, Makwa and yescrypt were given special recognition. The PHC
      recommends using Argon2 rather than legacy algorithms.
    '';
    homepage = "https://www.argon2.com/";
    license = with licenses; [ asl20 cc0 ];
    maintainers = with maintainers; [ taeer olynch ];
    mainProgram = "argon2";
    platforms = platforms.all;
  };
}
