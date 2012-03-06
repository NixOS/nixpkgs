args : with args;
	let localDefs = builderDefs.passthru.function {
		src =""; /* put a fetchurl here */
		buildInputs = [mkfontdir mkfontscale];
		configureFlags = [];
	};
	in with localDefs;
let
	doInstall = fullDepEntry ("
		mkdir -p \$out/share/fonts/
		cd \$out/share/fonts
		for i in ${toString paths}; do
			find \$i -type f -exec ln -s '{}' . ';' ;
		done
		mkfontdir 
		mkfontscale
	") [minInit addInputs defEnsureDir] ;
in
stdenv.mkDerivation rec {
	name = "wrapped-font-dir";
	builder = writeScript (name + "-builder")
		(textClosure localDefs [ doInstall doForceShare doPropagate]);
	meta = {
		description = "
		Just a wrapper to create fonts.dir and fonts.scale .
";
		inherit src;
	};
}
