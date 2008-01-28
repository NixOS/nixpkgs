args: with args;
stdenv.mkDerivation rec {
	name = "libunwind-0.98.6";
	src = fetchurl {
		url = "http://download.savannah.nongnu.org/releases/libunwind/${name}.tar.gz";
		sha256 = "1qfxqkyx4r5dmwajyhvsyyl8zwxs6n2rcg7a61fgfdfp0gxvpzgx";
	};
	configureFlags = "--enable-shared --disable-static";
	meta = {
		homepage = http://www.nongnu.org/libunwind;
		description = "The primary goal of this project is to define a portable
		and efficient API to determine the call-chain of a program";
	};
}
