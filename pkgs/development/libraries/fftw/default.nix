{ fetchurl, stdenv, builderDefs, precision ? "double" }:

assert stdenv.lib.elem precision [ "single" "double" "long-double" "quad-precision" ];

with { inherit (stdenv.lib) optional; };

let
  version = "3.3.3";
  localDefs = builderDefs.passthru.function {
    src =
      fetchurl {
        url = "ftp://ftp.fftw.org/pub/fftw/fftw-${version}.tar.gz";
        sha256 = "1wwp9b2va7vkq3ay7a9jk22nr4x5q6m37rzqy2j8y3d11c5grkc5";
      };
    buildInputs = [];
    configureFlags = [
        "--enable-shared" "--disable-static"
        "--enable-threads" "--enable-openmp" # very small wrappers
      ]
      ++ optional (precision != "double") "--enable-${precision}"
      # all x86_64 have sse2
      ++ optional stdenv.isx86_64 "--enable-sse2";
  };

in with localDefs;

stdenv.mkDerivation rec {
  name = "fftw-${precision}-${version}";
  builder = writeScript "${name}-builder"
    (textClosure localDefs [doConfigure doMakeInstall doForceShare]);
  meta = {
    description = "Fastest Fourier Transform in the West library";
  };
  passthru = {
    # Allow instantiating "-A fftw.src"
    inherit src;
  };
}

