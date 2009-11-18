args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://gnunet.org/libextractor/download/libextractor-0.5.18.tar.gz;
			sha256 = "09y869zmnr6n2953ra4y7z9m9nj23prlqa4nr4rwcb50dzdmil1k";
		};

		buildInputs = [ zlib];
		configureFlags = [];
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "libextractor-0.5.18";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "A tool to extract metadata from files";
		inherit src;
	};
}
