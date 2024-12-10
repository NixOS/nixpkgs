{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  python3,

  # Enable BLAS interface with 64-bit integer width.
  blas64 ? false,

  # Target architecture. "amdzen" compiles kernels for all Zen
  # generations. To build kernels for specific Zen generations,
  # use "zen", "zen2", "zen3", or "zen4".
  withArchitecture ? "amdzen",

  # Enable OpenMP-based threading.
  withOpenMP ? true,
}:

let
  threadingSuffix = lib.optionalString withOpenMP "-mt";
  blasIntSize = if blas64 then "64" else "32";

in
stdenv.mkDerivation rec {
  pname = "amd-blis";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "blis";
    rev = version;
    hash = "sha256-mLigzaA2S7qFCQT8UWC6bHWAvBjgpqvtgabPyFWBYT0=";
  };

  inherit blas64;

  nativeBuildInputs = [
    perl
    python3
  ];

  # Tests currently fail with non-Zen CPUs due to a floating point
  # exception in one of the generic kernels. Try to re-enable the
  # next release.
  doCheck = false;

  enableParallelBuilding = true;

  configureFlags =
    [
      "--enable-cblas"
      "--blas-int-size=${blasIntSize}"
    ]
    ++ lib.optionals withOpenMP [ "--enable-threading=openmp" ]
    ++ [ withArchitecture ];

  postPatch = ''
    patchShebangs configure build/flatten-headers.py
  '';

  postInstall = ''
    ls $out/lib
    ln -s $out/lib/libblis${threadingSuffix}.so $out/lib/libblas.so.3
    ln -s $out/lib/libblis${threadingSuffix}.so $out/lib/libcblas.so.3
    ln -s $out/lib/libblas.so.3 $out/lib/libblas.so
    ln -s $out/lib/libcblas.so.3 $out/lib/libcblas.so
  '';

  meta = with lib; {
    description = "BLAS-compatible library optimized for AMD CPUs";
    homepage = "https://developer.amd.com/amd-aocl/blas-library/";
    license = licenses.bsd3;
    maintainers = [ maintainers.markuskowa ];
    platforms = [ "x86_64-linux" ];
  };
}
