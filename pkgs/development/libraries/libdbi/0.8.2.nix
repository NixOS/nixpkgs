args : with args;
	with builderDefs {
		src = /* put a fetchurl here */
			fetchurl {
				url = mirror://sourceforge/libdbi/libdbi-0.8.2.tar.gz;
				sha256 = "01zlfv9hd4iv9v1xlh64ajdgx95jb0sjpazavapqc0zwiagwcg4d";
			};

		buildInputs = [];
		configureFlags = [];
	} null; /* null is a terminator for sumArgs */
stdenv.mkDerivation rec {
	name = "libdbi"+version;
	builder = writeScript (name + "-builder")
		(textClosure [doConfigure doMakeInstall doForceShare doPropagate]);
	meta = {
		description = "
	DB independent interface to DB.	
";
	};
}
