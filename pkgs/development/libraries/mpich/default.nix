{
  stdenv,
  lib,
  fetchurl,
  perl,
  gfortran,
  automake,
  autoconf,
  openssh,
  hwloc,
  python3,
  # either libfabric or ucx work for ch4backend on linux. On darwin, neither of
  # these libraries currently build so this argument is ignored on Darwin.
  ch4backend,
  # Process managers to build (`--with-pm`),
  # cf. https://github.com/pmodels/mpich/blob/b80a6d7c24defe7cdf6c57c52430f8075a0a41d6/README.vin#L562-L586
  withPm ? [
    "hydra"
    "gforker"
  ],
  pmix,
  # PMIX support is likely incompatible with process managers (`--with-pm`)
  # https://github.com/NixOS/nixpkgs/pull/274804#discussion_r1432601476
  pmixSupport ? false,
  # Enable Fortran support (disabled when cross compiling)
  fortranSupport ? stdenv.hostPlatform == stdenv.buildPlatform,
  targetPackages,
}:

let
  withPmStr = if withPm != [ ] then builtins.concatStringsSep ":" withPm else "no";
in

assert (ch4backend.pname == "ucx" || ch4backend.pname == "libfabric");

stdenv.mkDerivation rec {
  pname = "mpich";
  version = "4.3.2";

  src = fetchurl {
    url = "https://www.mpich.org/static/downloads/${version}/mpich-${version}.tar.gz";
    hash = "sha256-R9d0WHpxVqU3UiGMgRyFLnCsRNucUC3D85m0y4F+OBg=";
  };

  patches = [
    # Disables ROMIO test which was enabled in
    # https://github.com/pmodels/mpich/commit/09686f45d77b7739f7aef4c2c6ef4c3060946595
    # The test searches for mpicc in $out/bin, which is not yet present in the checkPhase
    # Moreover it fails one test.
    ./disable-romio-tests.patch
  ];

  outputs = [
    "out"
    "doc"
    "man"
  ];

  configureFlags = [
    "--enable-shared"
    "--with-pm=${withPmStr}"
  ]
  ++ lib.optionals (lib.versionAtLeast gfortran.version "10") [
    "FFLAGS=-fallow-argument-mismatch" # https://github.com/pmodels/mpich/issues/4300
    "FCFLAGS=-fallow-argument-mismatch"
  ]
  ++ lib.optionals pmixSupport [
    "--with-pmix"
  ]
  ++ lib.optionals (!fortranSupport) [
    "--disable-fortran"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    python3
    autoconf
    automake
    perl
  ]
  ++ lib.optional fortranSupport gfortran;
  buildInputs = [
    openssh
    hwloc
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) ch4backend
  ++ lib.optional pmixSupport pmix;

  # test_double_serializer.test fails on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  preFixup = ''
    # Ensure the default compilers are the ones mpich was built with
    sed -i 's:^CC=.*:CC=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}cc:' $out/bin/mpicc
    sed -i 's:^CXX=.*:CXX=${targetPackages.stdenv.cc}/bin/${targetPackages.stdenv.cc.targetPrefix}c++:' $out/bin/mpicxx
  ''
  + lib.optionalString fortranSupport ''
    sed -i 's:^FC=.*:FC=${targetPackages.gfortran or gfortran}/bin/${
      targetPackages.gfortran.targetPrefix or gfortran.targetPrefix
    }gfortran:' $out/bin/mpifort
  '';

  meta = {
    broken =
      # As far as we know, --with-pmix silently disables all of `--with-pm`.
      (pmixSupport && withPm != [ ])
      ||
        # When cross compiling fortan type sizes have to be set manually:
        # https://github.com/pmodels/mpich/issues/5380#issuecomment-866483882
        (fortranSupport && stdenv.hostPlatform != stdenv.buildPlatform);

    description = "Implementation of the Message Passing Interface (MPI) standard";

    longDescription = ''
      MPICH2 is a free high-performance and portable implementation of
      the Message Passing Interface (MPI) standard, both version 1 and
      version 2.
    '';
    homepage = "https://www.mpich.org";
    changelog = "https://github.com/pmodels/mpich/releases/tag/v${version}";
    license = {
      url = "https://github.com/pmodels/mpich/blob/15f59ab2b740539472dfd130f7fe01b61c28bba4/COPYRIGHT";
      fullName = "MPICH license (permissive)";
    };
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
