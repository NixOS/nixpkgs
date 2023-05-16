{ lib
, stdenv
, fetchFromSourcehut
, qbe
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "harec";
<<<<<<< HEAD
  version = "unstable-2023-04-25";
=======
  version = "unstable-2023-02-18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "harec";
<<<<<<< HEAD
    rev = "068e8da091f9053726251bc221abf40fdea630ff";
    hash = "sha256-PPR0d+6JJRzPURW7AznloBSrtylMJExNCGCxFMl2LsA=";
=======
    rev = "dd50ca7740408e3c6e41c0ca48b59b9f7f5911f2";
    hash = "sha256-616mPMdy4yHHuwGcq+aDdEOteEiWgufRzreXHGhmHr0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    qbe
  ];

  buildInputs = [
    qbe
  ];

  # TODO: report upstream
  hardeningDisable = [ "fortify" ];

  strictDeps = true;

  doCheck = true;

  meta = {
    homepage = "http://harelang.org/";
    description = "Bootstrapping Hare compiler written in C for POSIX systems";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.AndersonTorres ];
    # The upstream developers do not like proprietary operating systems; see
    # https://harelang.org/platforms/
    platforms = with lib.platforms;
      lib.intersectLists (freebsd ++ linux) (aarch64 ++ x86_64 ++ riscv64);
    badPlatforms = lib.platforms.darwin;
  };
})
