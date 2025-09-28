{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  python3,
  perl,
  gmpxx,
  mpfr,
  boost,
  eigen,
  gfortran,
  cmake,
  enableFMA ? stdenv.hostPlatform.fmaSupport,
  enableFortran ? true,
  enableSSE ? (!enableFortran) && stdenv.hostPlatform.isx86_64,

  # Maximum angular momentum of basis functions
  # 7 is required for def2/J auxiliary basis on 3d metals upwards
  maxAm ? 7,

  # ERI derivative order for 4-, 3- and 2-centre ERIs.
  # 2nd derivatives are defaults and allow gradients Hessians with density fitting
  # Setting them to zero disables derivatives.
  eriDeriv ? 2,
  eri3Deriv ? 2,
  eri2Deriv ? 2,

  # Angular momentum for derivatives of ERIs. Takes a list of length $DERIV_ORD+1.
  # Starting from index 0, each index i specifies the supported angular momentum
  # for the derivative order i, e.g. [6,5,4] supports ERIs for l=6, their first
  # derivatives for l=5 and their second derivatives for l=4.
  eriAm ? (builtins.genList (i: maxAm - 1 - i) (eriDeriv + 1)),
  eri3Am ? (builtins.genList (i: maxAm - i) (eri2Deriv + 1)),
  eri2Am ? (builtins.genList (i: maxAm - i) (eri2Deriv + 1)),

  # Same as above for optimised code. Higher optimisations take a long time.
  eriOptAm ? (builtins.genList (i: maxAm - 3 - i) (eriDeriv + 1)),
  eri3OptAm ? (builtins.genList (i: maxAm - 3 - i) (eri2Deriv + 1)),
  eri2OptAm ? (builtins.genList (i: maxAm - 3 - i) (eri2Deriv + 1)),

  # One-Electron integrals of all kinds including multipole integrals.
  # Libint does not build them and their derivatives by default.
  enableOneBody ? false,
  oneBodyDerivOrd ? 2,
  multipoleOrd ? 4, # Maximum order of multipole integrals, 4=octopoles

  # Whether to enable generic code if angular momentum is unsupported
  enableGeneric ? true,

  # Support integrals over contracted Gaussian
  enableContracted ? true,

  # Spherical harmonics/Cartesian orbital conventions
  cartGaussOrd ? "standard", # Ordering of Cartesian basis functions, "standard" is CCA
  shGaussOrd ? "standard", # Ordering of spherical harmonic basis functions. "standard" is -l to +l, "guassian" is 0, 1, -1, 2, -2, ...
  shellSet ? "standard",
  eri3PureSh ? false, # Transformation of 3-centre ERIs into spherical harmonics
  eri2PureSh ? false, # Transformation of 2-centre ERIs into spherical harmonics
}:

# Check that Fortran bindings are not used together with SIMD real type
assert (if enableFortran then !enableSSE else true);

# Check that a possible angular momentum for basis functions is used
assert (maxAm >= 1 && maxAm <= 8);

# Check for valid derivative order in ERIs
assert (eriDeriv >= 0 && eriDeriv <= 4);
assert (eri2Deriv >= 0 && eri2Deriv <= 4);
assert (eri3Deriv >= 0 && eri3Deriv <= 4);

# Ensure valid arguments for generated angular momenta in ERI derivatives are used.
assert (
  builtins.length eriAm == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (builtins.map (a: a <= maxAm && a >= 0) eriAm)
);
assert (
  builtins.length eri3Am == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (builtins.map (a: a <= maxAm && a >= 0) eri3Am)
);
assert (
  builtins.length eri2Am == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (builtins.map (a: a <= maxAm && a >= 0) eri2Am)
);

# Ensure valid arguments for generated angular momenta in optimised ERI derivatives are used.
assert (
  builtins.length eriOptAm == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (builtins.map (a: a <= maxAm && a >= 0) eriOptAm)
);
assert (
  builtins.length eri3OptAm == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (builtins.map (a: a <= maxAm && a >= 0) eri3OptAm)
);
assert (
  builtins.length eri2OptAm == eriDeriv + 1
  && builtins.foldl' (a: b: a && b) true (builtins.map (a: a <= maxAm && a >= 0) eri2OptAm)
);

# Ensure a valid derivative order for one-electron integrals
assert (oneBodyDerivOrd >= 0 && oneBodyDerivOrd <= 4);

# Check that valid basis shell orders are used, see https://github.com/evaleev/libint/wiki
assert (
  builtins.elem cartGaussOrd [
    "standard"
    "intv3"
    "gamess"
    "orca"
    "bagel"
  ]
);
assert (
  builtins.elem shGaussOrd [
    "standard"
    "gaussian"
  ]
);
assert (
  builtins.elem shellSet [
    "standard"
    "orca"
  ]
);

let
  pname = "libint";
  version = "2.11.1";

  meta = {
    description = "Library for the evaluation of molecular integrals of many-body operators over Gaussian functions";
    homepage = "https://github.com/evaleev/libint";
    license = with lib.licenses; [
      lgpl3Only
      gpl3Only
    ];
    maintainers = with lib.maintainers; [
      markuskowa
      sheepforce
    ];
    platforms = [ "x86_64-linux" ];
  };

  codeGen = stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "evaleev";
      repo = "libint";
      rev = "v${version}";
      hash = "sha256-oV/RWWfD0Kf2egI40fV8z2atG+4Cs+9+Wvy0euNNjtM=";
    };

    # Replace hardcoded "/bin/rm" with normal "rm"
    postPatch = ''
      for f in \
        bin/ltmain.sh \
        configure.ac \
        src/bin/libint/Makefile \
        src/lib/libint/Makefile.library \
        tests/eri/Makefile \
        tests/hartree-fock/Makefile \
        tests/unit/Makefile; do
          substituteInPlace $f --replace-warn "/bin/rm" "rm"
      done
    '';

    nativeBuildInputs = [
      autoconf
      automake
      libtool
      mpfr
      python3
      perl
      gmpxx
    ]
    ++ lib.optional enableFortran gfortran;

    buildInputs = [
      boost
      eigen
    ];

    configureFlags = [
      "--with-max-am=${builtins.toString maxAm}"
      "--with-eri-max-am=${lib.concatStringsSep "," (builtins.map builtins.toString eriAm)}"
      "--with-eri3-max-am=${lib.concatStringsSep "," (builtins.map builtins.toString eri3Am)}"
      "--with-eri2-max-am=${lib.concatStringsSep "," (builtins.map builtins.toString eri2Am)}"
      "--with-eri-opt-am=${lib.concatStringsSep "," (builtins.map builtins.toString eriOptAm)}"
      "--with-eri3-opt-am=${lib.concatStringsSep "," (builtins.map builtins.toString eri3OptAm)}"
      "--with-eri2-opt-am=${lib.concatStringsSep "," (builtins.map builtins.toString eri2OptAm)}"
      "--with-cartgauss-ordering=${cartGaussOrd}"
      "--with-shgauss-ordering=${shGaussOrd}"
      "--with-shell-set=${shellSet}"
    ]
    ++ lib.optional enableFMA "--enable-fma"
    ++ lib.optional (eriDeriv > 0) "--enable-eri=${builtins.toString eriDeriv}"
    ++ lib.optional (eri2Deriv > 0) "--enable-eri2=${builtins.toString eri2Deriv}"
    ++ lib.optional (eri3Deriv > 0) "--enable-eri3=${builtins.toString eri3Deriv}"
    ++ lib.optionals enableOneBody [
      "--enable-1body=${builtins.toString oneBodyDerivOrd}"
      "--enable-1body-property-derivs"
    ]
    ++ lib.optional (multipoleOrd > 0) "--with-multipole-max-order=${builtins.toString multipoleOrd}"
    ++ lib.optional enableGeneric "--enable-generic"
    ++ lib.optional enableContracted "--enable-contracted-ints"
    ++ lib.optional eri3PureSh "--enable-eri3-pure-sh"
    ++ lib.optional eri2PureSh "--enable-eri2-pure-sh";

    preConfigure = ''
      ./autogen.sh
    '';

    makeFlags = [ "export" ];

    installPhase = ''
      mkdir -p $out
      cp libint-${version}.tgz $out/.
    '';

    enableParallelBuilding = true;

    inherit meta;
  };

  codeComp = stdenv.mkDerivation {
    inherit pname version;

    src = "${codeGen}/libint-${version}.tgz";

    nativeBuildInputs = [
      python3
      cmake
    ]
    ++ lib.optional enableFortran gfortran;

    buildInputs = [
      boost
      eigen
    ];

    # Default is just "double", but SSE2 is available on all x86_64 CPUs.
    # AVX support is advertised, but does not work.
    # Fortran interface is incompatible with changing the LIBINT2_REALTYPE.
    cmakeFlags = [
      "-DLIBINT2_SHGAUSS_ORDERING=${shGaussOrd}"
    ]
    ++ lib.optional enableFortran "-DENABLE_FORTRAN=ON"
    ++ lib.optional enableSSE "-DLIBINT2_REALTYPE=libint2::simd::VectorSSEDouble";

    # Can only build in the source-tree. A lot of preprocessing magic fails otherwise.
    dontUseCmakeBuildDir = true;

    inherit meta;
  };

in
codeComp
