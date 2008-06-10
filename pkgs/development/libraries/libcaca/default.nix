{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "libcaca-0.99-beta13b";
  src = fetchurl {
	  name = "${name}.tar.gz";
    url = http://libcaca.zoy.org/attachment/wiki/libcaca/libcaca-0.99.beta13b.tar.gz?format=raw;
    sha256 = "0xy8pcnljnj5la97bzbwwyzyqa7dr3v9cyw8gdjzdfgqywvac1vg";
  };
  configureFlags = "--disable-x11 --disable-imlib2 --disable-doc";
  propagatedBuildInputs = [ncurses];

	meta = {
	  homepage = http://libcaca.zoy.org/;
		description = "A graphics library that outputs text instead of pixels.";
	  license = "WTFPL"; # http://sam.zoy.org/wtfpl/
	};
}
