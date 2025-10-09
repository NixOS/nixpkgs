{
  lib,
  stdenv,
  fetchFromGitLab,
  apfel,
  apfelgrid,
  applgrid,
  blas,
  ceres-solver,
  cmake,
  gfortran,
  gsl,
  lapack,
  lhapdf,
  libtirpc,
  libyaml,
  yaml-cpp,
  pkg-config,
  qcdnum,
  root,
  zlib,
}:

stdenv.mkDerivation {
  pname = "xfitter";
  version = "2.2.0";

  src = fetchFromGitLab {
    owner = "fitters";
    repo = "xfitter";
    rev = "refs/tags/2.2.0_Future_Freeze";
    domain = "gitlab.cern.ch";
    hash = "sha256-wanxgldvBEuAEOeVok3XgRVStcn9APd+Nj7vpRZUtGs=";
  };

  patches = [
    # Avoid need for -fallow-argument-mismatch
    ./0001-src-GetChisquare.f-use-correct-types-in-calls-to-DSY.patch
  ];

  nativeBuildInputs = [
    cmake
    gfortran
    pkg-config
  ];
  buildInputs = [
    apfel
    apfelgrid
    applgrid
    blas
    ceres-solver
    lhapdf
    lapack
    libyaml
    root
    qcdnum
    gsl
    yaml-cpp
    zlib
  ]
  ++ lib.optional (stdenv.hostPlatform.libc == "glibc") libtirpc;

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.hostPlatform.libc == "glibc"
  ) "-I${libtirpc.dev}/include/tirpc";
  NIX_LDFLAGS = lib.optional (stdenv.hostPlatform.libc == "glibc") "-ltirpc";

  hardeningDisable = [ "format" ];

  # workaround wrong library IDs
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -sv "$out/lib/xfitter/"* "$out/lib/"
  '';

  meta = with lib; {
    description = "Open source QCD fit framework designed to extract PDFs and assess the impact of new data";
    license = licenses.gpl3;
    homepage = "https://www.xfitter.org/xFitter";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}
