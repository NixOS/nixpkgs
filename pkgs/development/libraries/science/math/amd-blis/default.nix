{ lib, stdenv
, fetchFromGitHub
, perl
, python3

# Enable BLAS interface with 64-bit integer width.
, blas64 ? false

# Target architecture. "amd64" compiles kernels for all Zen
# generations. To build kernels for specific Zen generations,
# use "zen", "zen2", or "zen3".
, withArchitecture ? "amd64"

# Enable OpenMP-based threading.
, withOpenMP ? true
}:

let
  threadingSuffix = if withOpenMP then "-mt" else "";
  blasIntSize = if blas64 then "64" else "32";
in stdenv.mkDerivation rec {
  pname = "amd-blis";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "blis";
    rev = version;
    hash = "sha256-bbbeo1yOKse9pzbsB6lQ7pULKdzu3G7zJzTUgPXiMZY=";
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

  configureFlags = [
    "--enable-cblas"
    "--blas-int-size=${blasIntSize}"
  ] ++ lib.optionals withOpenMP [ "--enable-threading=openmp" ]
    ++ [ withArchitecture ];

  postPatch = ''
    patchShebangs configure build/flatten-headers.py
  '';

  postInstall = ''
    ln -s $out/lib/libblis${threadingSuffix}.so.3 $out/lib/libblas.so.3
    ln -s $out/lib/libblis${threadingSuffix}.so.3 $out/lib/libcblas.so.3
    ln -s $out/lib/libblas.so.3 $out/lib/libblas.so
    ln -s $out/lib/libcblas.so.3 $out/lib/libcblas.so
  '';

  meta = with lib; {
    description = "BLAS-compatible library optimized for AMD CPUs";
    homepage = "https://developer.amd.com/amd-aocl/blas-library/";
    license = licenses.bsd3;
    maintainers = [ maintainers.danieldk ];
    platforms = [ "x86_64-linux" ];
  };
}
