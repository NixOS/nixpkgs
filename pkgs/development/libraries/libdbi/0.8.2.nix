args : with args;
	let localDefs = builderDefs.passthru.function {
		src = /* put a fetchurl here */
			fetchurl {
				url = mirror://sourceforge/libdbi/libdbi-0.8.2.tar.gz;
				sha256 = "01zlfv9hd4iv9v1xlh64ajdgx95jb0sjpazavapqc0zwiagwcg4d";
			};

		buildInputs = [];
		configureFlags = [];
	};
	in with localDefs;
stdenv.mkDerivation rec {
	name = "libdbi-0.8.2";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "DB independent interface to DB";
		inherit src;
	};
}
