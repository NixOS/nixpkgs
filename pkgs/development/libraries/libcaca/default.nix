{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "libcaca-0.99-beta11";
  src = fetchurl {
    url = http://libcaca.zoy.org/files/libcaca-0.99.beta11.tar.gz;
    sha256 = "1kj0rkfbmq8kc3pi3p323ifx5yp9pcmbnxln7phxj5k4v7ngyld7";
  };
  configureFlags = "--disable-x11 --disable-imlib2 --disable-doc";
  propagatedBuildInputs = [ncurses];
}
