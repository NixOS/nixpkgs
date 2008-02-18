args: with args;
let rev = "2066"; in
stdenv.mkDerivation {
	name = "tapioca-qt-r${rev}";
	src = fetchsvn {
		url = "https://tapioca-voip.svn.sourceforge.net/svnroot/tapioca-voip/trunk/tapioca-qt";
		inherit rev;
		sha256 = "0r2qzlm56yizdi64xga6v2sdhdcgl3cvlsd7g9ynh95813nky88z";
	};

	buildInputs = [cmake];
	propagatedBuildInputs = [telepathy_qt stdenv.gcc.libc];
	meta = {
		description = "Qt Tapioca binding library";
	};
}
