args : with args; with builderDefs;
	let localDefs = builderDefs.passthru.function (rec {
		src = /* put a fetchurl here */
		fetchurl {
		  url = http://prdownloads.sourceforge.net/junicode/junicode-0.6.15.zip;
		  sha256 = "0p16r5s6qwyz0hayb6k61s5r2sfachlx7r6gpqqx5myx6ipbfdns";
		};

		buildInputs = [unzip];
		configureFlags = [];
		doInstall = fullDepEntry (''
			unzip ${src}
			ensureDir $out/share/fonts/junicode-ttf
			cp *.ttf $out/share/fonts/junicode-ttf
		'') ["minInit" "addInputs" "defEnsureDir"];
	});
	in with localDefs;
stdenv.mkDerivation rec {
	name = "junicode-0.6.15";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doInstall doForceShare doPropagate]);
	meta = {
		description = "A Unicode font";
		inherit src;
	};
}



