{ stdenv
, fetchFromGitHub
, perl
, python3

# Enable BLAS interface with 64-bit integer width.
, blas64 ? false

# Target architecture. x86_64 builds Intel and AMD kernels.
, withArchitecture ? "x86_64"

# Enable OpenMP-based threading.
, withOpenMP ? true
}:

let
  blasIntSize = if blas64 then "64" else "32";
in stdenv.mkDerivation rec {
  pname = "blis";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "flame";
    repo = "blis";
    rev = version;
    sha256 = "13g9kg7x8j9icg4frdq3wpl2cmp0jnh93mw48daa7ym399w17423";
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
    ln -s $out/lib/libblis.so.3 $out/lib/libblas.so.3
    ln -s $out/lib/libblis.so.3 $out/lib/libcblas.so.3
    ln -s $out/lib/libblas.so.3 $out/lib/libblas.so
    ln -s $out/lib/libcblas.so.3 $out/lib/libcblas.so
  '';

  meta = with stdenv.lib; {
    description = "BLAS-compatible linear algebra library";
    homepage = "https://github.com/flame/blis";
    license = licenses.bsd3;
    maintainers = [ maintainers.danieldk ];
    platforms = [ "x86_64-linux" ];
  };
}
