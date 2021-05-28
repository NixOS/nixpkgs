{ stdenv
, fetchFromGitHub
, perl
, python3

# Enable BLAS interface with 64-bit integer width.
, blas64 ? false

# Target architecture, use "zen" or "zen2", optimization for Zen and
# other families is pretty much mutually exclusive in the AMD fork of
# BLIS.
, withArchitecture ? "zen"

# Enable OpenMP-based threading.
, withOpenMP ? true
}:

let
  threadingSuffix = if withOpenMP then "-mt" else "";
  blasIntSize = if blas64 then "64" else "32";
in stdenv.mkDerivation rec {
  pname = "amd-blis";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "amd";
    repo = "blis";
    rev = version;
    sha256 = "1b2f5bwi0gkw2ih2rb7wfzn3m9hgg7k270kg43rmzpr2acpy86xa";
  };

  inherit blas64;

  nativeBuildInputs = [
    perl
    python3
  ];

  doCheck = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-cblas"
    "--blas-int-size=${blasIntSize}"
  ] ++ stdenv.lib.optionals withOpenMP [ "--enable-threading=openmp" ]
    ++ [ withArchitecture ];

  postPatch = ''
    patchShebangs configure build/flatten-headers.py
  '';

  postInstall = ''
    ln -s $out/lib/libblis${threadingSuffix}.so.2 $out/lib/libblas.so.3
    ln -s $out/lib/libblis${threadingSuffix}.so.2 $out/lib/libcblas.so.3
    ln -s $out/lib/libblas.so.3 $out/lib/libblas.so
    ln -s $out/lib/libcblas.so.3 $out/lib/libcblas.so
  '';

  meta = with stdenv.lib; {
    description = "BLAS-compatible library optimized for AMD CPUs";
    homepage = "https://developer.amd.com/amd-aocl/blas-library/";
    license = licenses.bsd3;
    maintainers = [ maintainers.danieldk ];
    platforms = [ "x86_64-linux" ];
  };
}
