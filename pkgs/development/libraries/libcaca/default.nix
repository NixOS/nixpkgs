{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "libcaca-0.99-beta13b";
  src = fetchurl {
    url = http://libcaca.zoy.org/files/libcaca-0.99.beta13b.tar.gz;
    sha256 = "0xy8pcnljnj5la97bzbwwyzyqa7dr3v9cyw8gdjzdfgqywvac1vg";
  };
  configureFlags = "--disable-x11 --disable-imlib2 --disable-doc";
  propagatedBuildInputs = [ncurses];
}
