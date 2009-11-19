args : with args; with builderDefs;
	let localDefs = builderDefs.passthru.function (rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://crl.nmsu.edu/~mleisher/cu/cu12-1.9.tar.gz;
			sha256 = "0256h6f3ky529jc39hh0nvkngy48a0x3gss2z81g5ddi1qzfw0pn";
		};
		buildInputs = [mkfontdir mkfontscale];
		configureFlags = [];
		doInstall = fullDepEntry (''
			tar xf ${src}
			ensureDir $out/share/fonts/
			cp *.bdf $out/share/fonts
			cd $out/share/fonts
			mkfontdir 
			mkfontscale
		'') ["minInit" "defEnsureDir" "addInputs"];
	});
	in with localDefs;
stdenv.mkDerivation rec {
	name = "clearlyU-12-1.9";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doInstall doForceShare doPropagate]);
	meta = {
		description = "A Unicode font";
		inherit src;
	};
}
