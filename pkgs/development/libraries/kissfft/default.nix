{ lib
, stdenv
, fetchFromGitHub
, fftw
, fftwFloat
, python3
, datatype ? "double"
, withTools ? false
, libpng
, enableStatic ? stdenv.hostPlatform.isStatic
, enableOpenmp ? false
, llvmPackages
}:
let
  py = python3.withPackages (ps: with ps; [ numpy ]);
  option = cond: if cond then "1" else "0";
in
stdenv.mkDerivation rec {
  pname = "kissfft-${datatype}${lib.optionalString enableOpenmp "-openmp"}";
  version = "131.1.0";

  src = fetchFromGitHub {
    owner = "mborgerding";
    repo = "kissfft";
    rev = version;
    sha256 = "1yfws5bn4kh62yk6hdyp9h9775l6iz7wsfisbn58jap6b56s8j5s";
  };

  patches = [
    ./0001-pkgconfig-darwin.patch
  ];

  # https://bugs.llvm.org/show_bug.cgi?id=45034
  postPatch = lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.cc.isClang && lib.versionOlder stdenv.cc.version "10") ''
    substituteInPlace test/Makefile \
      --replace "-ffast-math" ""
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin) ''
    substituteInPlace test/Makefile \
      --replace "LD_LIBRARY_PATH" "DYLD_LIBRARY_PATH"
    # Don't know how to make math.h's double long constants available
    substituteInPlace test/testcpp.cc \
      --replace "M_PIl" "M_PI"
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "KISSFFT_DATATYPE=${datatype}"
    "KISSFFT_TOOLS=${option withTools}"
    "KISSFFT_STATIC=${option enableStatic}"
    "KISSFFT_OPENMP=${option enableOpenmp}"
  ];

  buildInputs = lib.optionals (withTools && datatype != "simd") [ libpng ]
    # TODO: This may mismatch the LLVM version in the stdenv, see #79818.
    ++ lib.optional (enableOpenmp && stdenv.cc.isClang) llvmPackages.openmp;

  doCheck = true;

  nativeCheckInputs = [
    py
    (if datatype == "float" then fftwFloat else fftw)
  ];

  checkFlags = [ "testsingle" ];

  postInstall = ''
    ln -s ${pname}.pc $out/lib/pkgconfig/kissfft.pc
  '';

  # Tools can't find kissfft libs on Darwin
  postFixup = lib.optionalString (withTools && stdenv.hostPlatform.isDarwin) ''
    for bin in $out/bin/*; do
      install_name_tool -change lib${pname}.dylib $out/lib/lib${pname}.dylib $bin
    done
  '';

  meta = with lib; {
    description = "Mixed-radix Fast Fourier Transform based up on the KISS principle";
    homepage = "https://github.com/mborgerding/kissfft";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.all;
  };
}
