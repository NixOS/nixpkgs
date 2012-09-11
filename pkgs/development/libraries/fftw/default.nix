{fetchurl, stdenv, builderDefs, stringsWithDeps, singlePrecision ? false, pthreads ? false}:
let
  version = "3.3.2";
  localDefs = builderDefs.passthru.function { 
  src = 
    fetchurl {
      url = "ftp://ftp.fftw.org/pub/fftw/fftw-${version}.tar.gz";
      sha256 = "b1236a780ca6e66fc5f8eda6ef0665d680e8253d9f01d7bf211b714a50032d01";
    };
  buildInputs = [];
  configureFlags = ["--enable-shared"]
                        # some distros seem to be shipping both versions within the same package?
                        # why does --enable-float still result in ..3f.so instead of ..3.so?
                   ++ (if singlePrecision then [ "--enable-single" ] else [ ])
		   ++ (stdenv.lib.optional (!pthreads) "--enable-openmp")
		   ++ (stdenv.lib.optional pthreads "--enable-threads")
                        # I think all i686 has sse
                   ++ (if (stdenv.isi686 || stdenv.isx86_64) && singlePrecision then [ "--enable-sse" ] else [ ])
                        # I think all x86_64 has sse2
                   ++ (if stdenv.isx86_64 && ! singlePrecision then [ "--enable-sse2" ] else [ ]);
                
  };
in with localDefs;
stdenv.mkDerivation {
  name = "fftw-3.3.2" + ( if singlePrecision then "-single" else "-double" );
  builder = writeScript "fftw-3.3.2-builder"
    (textClosure localDefs [doConfigure doMakeInstall doForceShare]);
  meta = {
    description = "Fastest Fourier Transform in the West library";
  };
  passthru = {
    # Allow instantiating "-A fftw.src"
    inherit src;
  };
}
