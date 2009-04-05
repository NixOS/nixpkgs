args : with args;
	let localDefs = builderDefs.passthru.function { 
		src = 
			fetchurl {
				url = ftp://ftp.fftw.org/pub/fftw/fftw-3.2.1.tar.gz;
				sha256 = "1x8jww3vflrgzjrpnnsk0020bkd9aqmfga8y31v10cqd02l46sh7";
			};
		buildInputs = [];
		configureFlags = ["--enable-shared"] 
                     ++ (if args.singlePrecision then [ /*"--enable-single" */] else ["--enable-float"]);
                          # some distros seem to be shipping both versions within the same package?
                          # why does --enable-single still result in ..3f.so instead of ..3.so?
	};
	in with localDefs;
stdenv.mkDerivation {
	name = "fftw-3.2.1" + ( if args.singlePrecision then "-single" else "-float" );
	builder = writeScript "fftw-3.2.1-builder"
		(textClosure localDefs [doConfigure doMakeInstall doForceShare]);
	meta = {
		description = "Fastest Fourier Transform in the West library";
		inherit src;
	};
}
