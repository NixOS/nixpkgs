{ lib
, stdenv
, fetchFromSourcehut
, qbe
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "harec";
  version = "unstable-2023-02-18";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "harec";
    rev = "dd50ca7740408e3c6e41c0ca48b59b9f7f5911f2";
    hash = "sha256-616mPMdy4yHHuwGcq+aDdEOteEiWgufRzreXHGhmHr0=";
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
