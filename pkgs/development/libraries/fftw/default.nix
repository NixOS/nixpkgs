args : with args;
	let localDefs = builderDefs.passthru.function { 
		src = 
			fetchurl {
				url = ftp://ftp.fftw.org/pub/fftw/fftw-3.1.2.tar.gz;
				sha256 = "1gr63hf5vvsg50b2xwqaxwpvs1y9g8l0sb91a38wpvr7zsbjxfg1";
			};
		buildInputs = [];
		configureFlags = ["--enable-shared"] 
                     ++ (if args.singlePrecision then [ /*"--enable-single" */] else ["--enable-float"]);
                          # some distros seem to be shipping both versions within the same package?
                          # why does --enable-single still result in ..3f.so instead of ..3.so?
	};
	in with localDefs;
stdenv.mkDerivation {
	name = "fftw-3.1.2" + ( if args.singlePrecision then "-single" else "-float" );
	builder = writeScript "fftw-3.1.2-builder"
		(textClosure localDefs [doConfigure doMakeInstall doForceShare]);
	meta = {
		description = "Fastest Fourier Transform in the West library";
		inherit src;
	};
}
