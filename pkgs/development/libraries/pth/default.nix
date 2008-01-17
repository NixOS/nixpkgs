args: with args;
stdenv.mkDerivation rec {
	name = "pth-2.0.7";
	
	src = fetchurl {
		url = "mirror://gnu/pth/${name}.tar.gz";
		sha256 = "0ckjqw5kz5m30srqi87idj7xhpw6bpki43mj07bazjm2qmh3cdbj";
	};

	meta = {
		description = "The GNU Portable Threads";
		homepage = http://www.gnu.org/software/pth;
	};
}
