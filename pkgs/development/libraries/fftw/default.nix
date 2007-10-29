args : with args;
	with builderDefs {
		src = 
			fetchurl {
				url = ftp://ftp.fftw.org/pub/fftw/fftw-3.1.2.tar.gz;
				sha256 = "1gr63hf5vvsg50b2xwqaxwpvs1y9g8l0sb91a38wpvr7zsbjxfg1";
			};
		buildInputs = [];
		configureFlags = ["--enable-float --enable-shared"];
	} null;
	with stringsWithDeps;
stdenv.mkDerivation {
	name = "fftw-3.1.2";
	builder = writeScript "fftw-3.1.2-builder"
		(textClosure [doConfigure doMakeInstall doForceShare]);
	meta = {
		description = "
	Fastest Fourier Transform in the West library.
";
	};
}
