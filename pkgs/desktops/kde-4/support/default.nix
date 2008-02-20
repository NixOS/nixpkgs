oldArgs:
let
	args = oldArgs // {
	svnSrc = name: hash:
	oldArgs.fetchsvn {
		url = "svn://anonsvn.kde.org/home/kde/trunk/kdesupport/${name}";
		rev = 747269;
		sha256 = hash;
	};
	};
in
rec {
	akode = (import ./akode.nix) args;
	eigen = (import ./eigen.nix) args;
	gmm = (import ./gmm.nix) args;
	qca = (import ./qca.nix) args;
	qimageblitz = (import ./qimageblitz.nix) args;
	soprano = (import ./soprano.nix) args;
	strigi = (import ./strigi.nix) args;
	taglib = (import ./taglib.nix) args;
	all = [qca gmm eigen taglib soprano strigi qimageblitz];
}
