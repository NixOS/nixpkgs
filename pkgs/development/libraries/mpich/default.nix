{
  stdenv,
  lib,
  fetchurl,
  autoconf,
  automake,
  gfortran,
  hwloc,
  openssh,
  perl,
  python3,
  removeReferencesTo,
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
}:

let
  withPmStr = if withPm != [ ] then builtins.concatStringsSep ":" withPm else "no";

  # Binaries that should go in the "dev" output.
  # These are all MPI compilers (wrappers around gcc, really).
  develBins = [
    "bin/mpicc"
    "bin/mpic++"
    "bin/mpicxx"
    "bin/mpif77"
    "bin/mpif90"
    "bin/mpifort"
  ];

  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in

assert (ch4backend.pname == "ucx" || ch4backend.pname == "libfabric");

stdenv.mkDerivation rec {
  pname = "mpich";
  version = "5.0.0";

  src = fetchurl {
    url = "https://www.mpich.org/static/downloads/${version}/mpich-${version}.tar.gz";
    hash = "sha256-6TUOMiJCg+lTEfIhNPNsmOPNHGZdF/riCmzJLtPP/hE=";
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
    "bin"
    "dev"
    "doc"
    "man"
  ];

  configureFlags = [
    "--enable-shared"
    "--with-pm=${withPmStr}"

    # NOTE: /etc is meant to contain MPICH configuration for both *compilers* (dev) and for *runtime* (out, bin).
    #   /etc/mpixxx_opts.conf is a *compiler* configuration file.
    #   /etc/mpiexec.hydra.conf is a *runtime* configuration file.
    #
    # Ideally we'd be able to specify those separately. However, the build currently doesn't install mpiexec.hydra.conf
    # at all, but it does install mpixxx_opts.conf. So we configure the sysconfdir to be a "dev" output, since the only
    # file that's installed is needed by compilers, not runtime.
    # If we ever need both, we should probably have a separate "etc" output.
    "--sysconfdir=${placeholder "dev"}/etc"
  ]
  ++ lib.optionals pmixSupport [
    "--with-pmix"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoconf
    automake
    gfortran
    python3
    removeReferencesTo
  ];
  buildInputs = [
    perl
    openssh
    hwloc
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) ch4backend
  ++ lib.optional pmixSupport pmix;

  # test_double_serializer.test fails on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  postInstall =
    # Move compiler binaries into $dev.
    ''
      for f in ${lib.concatStringsSep " " develBins}; do
        moveToOutput "$f" "''${!outputDev}"
      done
    ''
    # Ensure the default compilers are the ones mpich was built with
    + ''
      sed -i 's:CC="gcc":CC=${stdenv.cc}/bin/gcc:' "$dev"/bin/mpicc
      sed -i 's:CXX="g++":CXX=${stdenv.cc}/bin/g++:' "$dev"/bin/mpicxx
      sed -i 's:FC="gfortran":FC=${gfortran}/bin/gfortran:' "$dev"/bin/mpifort
    '';

  # The entire configure line is embedded into some binaries, so we can end up with cycles between
  # outputs, or one output depending on all other outputs. Since the configure line embedding does
  # not affect functionality, we can simply break its references.
  #
  # To find the cycles, temporarily add this to postFixup to print them out:
  #   for i in out bin dev doc man; do
  #     for j in out bin dev doc man; do
  #       if [ "$i" != "$j" ]; then
  #         echo "$i in $j: --------------------------------"
  #         grep -r "''${!i}" "''${!j}" || true
  #       fi
  #     done
  #   done
  postFixup = ''
    remove-references-to \
      -t "''${!outputBin}" \
      -t "''${!outputDev}" \
      -t "''${!outputDoc}" \
      -t "''${!outputMan}" \
      $(find "$out"/lib -type f -name 'libmpi${libExt}*')
    remove-references-to \
      -t "''${!outputDev}" \
      -t "''${!outputDoc}" \
      -t "''${!outputMan}" \
      $(find "$bin"/bin -type f)
  '';

  meta = {
    # As far as we know, --with-pmix silently disables all of `--with-pm`
    broken = pmixSupport && withPm != [ ];

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
    maintainers = [ lib.maintainers.markuskowa ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
