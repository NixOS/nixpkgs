args : with args; with builderDefs {src="";} null;
	let localDefs = builderDefs (rec {
		src = /* put a fetchurl here */
		fetchurl {
			url = http://prdownloads.sourceforge.net/wqy/wqy-zenhei-0.4.23-1.tar.gz;
			sha256 = "138nn81ai240av0xvcq4ab3rl73n0qlj3gwr3a36i63ry8vdj5qm";
		};

		buildInputs = [];
		configureFlags = [];
		doInstall = FullDepEntry (''
			ensureDir $out/share/fonts
			cp *.ttf $out/share/fonts
		'') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];
	}) null; /* null is a terminator for sumArgs */
	in with localDefs;
stdenv.mkDerivation rec {
	name = "wqy-zenhei-"+version;
	builder = writeScript (name + "-builder")
		(textClosure localDefs 
			[doInstall doForceShare doPropagate]);
	meta = {
		description = "
		A (mainly) Chinese Unicode font.
";
	};
}

