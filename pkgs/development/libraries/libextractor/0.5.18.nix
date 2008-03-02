args : with args;
	let localDefs = builderDefs {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://gnunet.org/libextractor/download/libextractor-0.5.18.tar.gz;
			sha256 = "09y869zmnr6n2953ra4y7z9m9nj23prlqa4nr4rwcb50dzdmil1k";
		};

		buildInputs = [ zlib];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "libextractor"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
	Libextractor - extracts metadata from files.
";
		inherit src;
	};
}
