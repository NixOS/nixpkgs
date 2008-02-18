args: with args;
let
  rev = "773861";
in
stdenv.mkDerivation {
	name = "decibel-r${rev}";

	src = fetchsvn {
		url = svn://anonsvn.kde.org/home/kde/trunk/playground/pim/decibel;
    sha256 = "073fksn5dl7vkkiwvl9s56n9ymnlxy27kbz1h1fryq6r8x924vjc";
    inherit rev;
	};

	propagatedBuildInputs = [ kde4.libs tapioca_qt ];
  buildInputs = [cmake];
}
