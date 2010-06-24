{fetchurl, stdenv, builderDefs, stringsWithDeps, singlePrecision ? false}:
let localDefs = builderDefs.passthru.function { 
  src = 
    fetchurl {
      url = ftp://ftp.fftw.org/pub/fftw/fftw-3.2.2.tar.gz;
      sha256 = "13vnglardq413q2518zi4a8pam3znydrz28m9w09kss9xrjsx9va";
    };
  buildInputs = [];
  configureFlags = ["--enable-shared" "--enable-openmp"]
                        # some distros seem to be shipping both versions within the same package?
                        # why does --enable-float still result in ..3f.so instead of ..3.so?
                   ++ (if singlePrecision then [ "--enable-single" ] else [ ])
                        # I think all i686 has sse
                   ++ (if (stdenv.isi686 || stdenv.isx86_64) && singlePrecision then [ "--enable-sse" ] else [ ])
                        # I think all x86_64 has sse2
                   ++ (if stdenv.isx86_64 && ! singlePrecision then [ "--enable-sse2" ] else [ ]);
                
  };
in with localDefs;
stdenv.mkDerivation {
  name = "fftw-3.2.2" + ( if singlePrecision then "-single" else "-double" );
  builder = writeScript "fftw-3.2.1-builder"
    (textClosure localDefs [doConfigure doMakeInstall doForceShare]);
  meta = {
    description = "Fastest Fourier Transform in the West library";
  };
  passthru = {
    # Allow instantiating "-A fftw.src"
    inherit src;
  };
}
