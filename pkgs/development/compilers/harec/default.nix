{ lib
, stdenv
, fetchFromSourcehut
, qbe
, fetchgit
}:
let
  # harec needs the dbgfile and dbgloc features implemented up to this commit.
  # This can be dropped once 1.2 is released, for a possible release date see:
  # https://lists.sr.ht/~mpu/qbe/%3CZPkmHE9KLohoEohE%40cloudsdale.the-delta.net.eu.org%3E
  qbe' = qbe.overrideAttrs (_old: {
    version = "1.1-unstable-2023-08-18";
    src = fetchgit {
      url = "git://c9x.me/qbe.git";
      rev = "36946a5142c40b733d25ea5ca469f7949ee03439";
      hash = "sha256-bqxWFP3/aw7kRoD6ictbFcjzijktHvh4AgWAXBIODW8=";
    };
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "harec";
  version = "unstable-2023-10-22";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "harec";
    rev = "64dea196ce040fbf3417e1b4fb11331688672aca";
    hash = "sha256-2Aeb+OZ/hYUyyxx6aTw+Oxiac+p+SClxtg0h68ZBSHc=";
  };

  nativeBuildInputs = [
    qbe'
  ];

  buildInputs = [
    qbe'
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    # We create this attribute so that the `hare` package can access the
    # overwritten `qbe`.
    qbeUnstable = qbe';
  };

  meta = {
    homepage = "https://harelang.org/";
    description = "Bootstrapping Hare compiler written in C for POSIX systems";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onemoresuza ];
    mainProgram = "harec";
    # The upstream developers do not like proprietary operating systems; see
    # https://harelang.org/platforms/
    # UPDATE: https://github.com/hshq/harelang provides a MacOS port
    platforms = with lib.platforms;
      lib.intersectLists (freebsd ++ linux) (aarch64 ++ x86_64 ++ riscv64);
    badPlatforms = lib.platforms.darwin;
  };
})
