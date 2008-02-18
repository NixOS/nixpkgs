args: with args;
let rev = "2031"; in
stdenv.mkDerivation {
	name = "telepathy-qt-r${rev}";
	src = fetchsvn {
		url = "https://tapioca-voip.svn.sourceforge.net/svnroot/tapioca-voip/trunk/telepathy-qt";
		inherit rev;
		sha256 = "0d7psgc8nr5bryrjgfg92622hbilp0qwx0pya3836bz2l6x3msnb";
	};

	buildInputs = [cmake];
	propagatedBuildInputs = [qt stdenv.gcc.libc];
	meta = {
		description = "Qt bindings for telepathy";
	};
}
