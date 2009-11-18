args : with args; with builderDefs;
	let localDefs = builderDefs.passthru.function (rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://prdownloads.sourceforge.net/wqy/wqy-zenhei-0.4.23-1.tar.gz;
			sha256 = "138nn81ai240av0xvcq4ab3rl73n0qlj3gwr3a36i63ry8vdj5qm";
		};

		buildInputs = [];
		configureFlags = [];
		doInstall = fullDepEntry (''
			ensureDir $out/share/fonts
			cp *.ttf $out/share/fonts
		'') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];
	});
	in with localDefs;
stdenv.mkDerivation rec {
	name = "wqy-zenhei-0.4.23-1";
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doInstall doForceShare doPropagate]);
	meta = {
		description = "A (mainly) Chinese Unicode font";
		inherit src;
	};
}

