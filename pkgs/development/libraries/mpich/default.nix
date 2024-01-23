{
  stdenv,
  lib,
  fetchurl,
  callPackage,
  perl,
  gfortran,
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
  ] ++ lib.optionals (withPmi == "pmi1") [
    "gforker"
  ],
  pmix,
  # PMIX support is likely incompatible with process managers (`--with-pm`)
  # https://github.com/NixOS/nixpkgs/pull/274804#discussion_r1432601476
  enablePmix ? false,
  withPmi ? if enablePmix then "pmix" else "pmi2",
  # --with-pmilib is a transitionary interface, update with 4.2.0
  withPmilib ? if enablePmix then "default" else "slurm",
  enablePmi1 ? false,
  enablePmi2 ? !enablePmix,
  slurm,
}:

let
  withPmStr = if withPm != [ ] then builtins.concatStringsSep ":" withPm else "no";

  # MPICH doesn't support the autoconf-style --without-feature and
  # --disable-feature flags:
  mpichWith =
    cond: feature:
    assert builtins.isBool cond;
    if cond then "--with-${feature}" else "--with-${feature}=no";
  mpichWithAs =
    cond: feature: value:
    assert builtins.isBool cond;
    if cond then "--with-${feature}=${value}" else "--with-${feature}=no";
in

assert (ch4backend.pname == "ucx" || ch4backend.pname == "libfabric");

stdenv.mkDerivation  rec {
  pname = "mpich";
  version = "4.1.2";

  src = fetchurl {
    url = "https://www.mpich.org/static/downloads/${version}/mpich-${version}.tar.gz";
    sha256 = "sha256-NJLpitq2K1l+8NKS+yRZthI7yABwqKoKML5pYgdaEvA=";
  };

  outputs = [ "out" "doc" "man" ];

  configureFlags =
    [
      "--enable-shared"
      (mpichWithAs true "pm" withPmStr)
      (mpichWithAs true "pmi" withPmi)
      (mpichWithAs true "pmilib" withPmilib)

      # --with-pmi{1,2,x} declared at
      # https://github.com/pmodels/mpich/blob/c2f04da1b3371b0e85c77761649adfa30a0f5269/configure.ac#L1537-L1539
      (mpichWith enablePmix "pmix")
    ]
    ++ lib.optionals (enablePmi1 != null) [
      (mpichWith enablePmi1 "pmi1")
    ]
    ++ lib.optionals (enablePmi2 != null) [
      (mpichWith enablePmi2 "pmi2")
    ]
    ++ lib.optionals (lib.versionAtLeast gfortran.version "10") [
      "FFLAGS=-fallow-argument-mismatch" # https://github.com/pmodels/mpich/issues/4300
      "FCFLAGS=-fallow-argument-mismatch"
    ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    gfortran
    python3
  ];
  buildInputs =
    [
      perl
      openssh
      hwloc
      (lib.getLib slurm)
      (lib.getDev slurm)
    ]
    ++ lib.optionals (enablePmi1 != null && enablePmi1) [
      # Slurm's libpmi.so currently hard-codes a path to $out,
      # so we put it in the same output as the binaries
      (lib.getBin slurm)
    ]
    ++ lib.optionals (!stdenv.isDarwin) [ ch4backend ]
    ++ lib.optionals enablePmix [ pmix ];

  doCheck = true;

  preFixup = ''
    # Ensure the default compilers are the ones mpich was built with
    sed -i 's:CC="gcc":CC=${stdenv.cc}/bin/gcc:' $out/bin/mpicc
    sed -i 's:CXX="g++":CXX=${stdenv.cc}/bin/g++:' $out/bin/mpicxx
    sed -i 's:FC="gfortran":FC=${gfortran}/bin/gfortran:' $out/bin/mpifort
  '';

  passthru.tests.samples = callPackage ./tests { };

  meta = with lib; {
    broken =
      let
        anyFailed = builtins.any (x: !x);
      in
      anyFailed [
        # As far as we know, --with-pmix silently disables all of `--with-pm`
        (enablePmix -> withPm == [ ])
        (enablePmix -> !(enablePmi1 || enablePmi2))

        (!(enablePmi1 && enablePmi2)) # Reconsider with 4.2.*

        # Mirroring
        # https://github.com/pmodels/mpich/blob/v4.1.2/configure.ac#L1476-L1514
        #
        # This gets simplified with 4.2.*
        (builtins.elem withPmi [
          null
          "bgq"
          "cray"
          "default"
          "pmi1"
          "pmi2"
          "pmi2/simple"
          "pmix"
          "simple"
          "slurm"
        ])

        (builtins.elem enablePmi1 [
          null
          true
          false
        ])
        (builtins.elem enablePmi2 [
          null
          true
          false
        ])
      ];

    description = "Implementation of the Message Passing Interface (MPI) standard";

    longDescription = ''
      MPICH2 is a free high-performance and portable implementation of
      the Message Passing Interface (MPI) standard, both version 1 and
      version 2.
    '';
    homepage = "http://www.mcs.anl.gov/mpi/mpich2/";
    license = {
      url = "http://git.mpich.org/mpich.git/blob/a385d6d0d55e83c3709ae851967ce613e892cd21:/COPYRIGHT";
      fullName = "MPICH license (permissive)";
    };
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
