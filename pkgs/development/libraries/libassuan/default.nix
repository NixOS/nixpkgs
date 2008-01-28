args: with args;
stdenv.mkDerivation rec {
	name = "libassuan-1.0.4";

	src = fetchurl {
		url = "ftp://ftp.gnupg.org/gcrypt/libassuan/${name}.tar.bz2";
		sha256 = "1milkb5128nkgvfvfc9yi3qq8d1bvci7b3qmzfibmyh7qga6pwpw";
	};

	propagatedBuildInputs = [pth];

	meta = {
		description = "Libassuan  is the IPC library used by some GnuPG related software";
		homepage = http://www.gnupg.org;
	};
}
