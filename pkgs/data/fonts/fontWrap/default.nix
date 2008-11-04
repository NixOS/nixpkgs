args : with args;
	let localDefs = builderDefs.passthru.function {
		src =""; /* put a fetchurl here */
		buildInputs = [mkfontdir mkfontscale ttmkfdir];
		configureFlags = [];
	};
	in with localDefs;
let
	doInstall = FullDepEntry ("
		ensureDir \$out/share/fonts/
		cd \$out/share/fonts
		for i in ${toString paths}; do
			find \$i -type f -exec ln -s '{}' . ';' ;
		done
		mkfontdir 
		mkfontscale
		mv fonts.scale fonts.scale.old
		mv fonts.dir fonts.dir.old
		ttmkfdir
		cat fonts.dir.old >> fonts.dir
		cat fonts.scale.old >> fonts.scale
		rm fonts.dir.old fonts.scale.old
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
