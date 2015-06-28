{stdenv, fetchurl, ncurses, automake}:

stdenv.mkDerivation {
  name = "aalib-1.4rc5";

  src = fetchurl {
    url = mirror://sourceforge/aa-project/aalib-1.4rc5.tar.gz;
    sha256 = "1vkh19gb76agvh4h87ysbrgy82hrw88lnsvhynjf4vng629dmpgv";
  };

  # The fuloong2f is not supported by aalib still
  preConfigure = ''
    cp ${automake}/share/automake*/config.{sub,guess} .
  '';

  buildInputs = [ ncurses ];

  configureFlags = "--without-x --with-ncurses=${ncurses}";

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./darwin.patch ];

  meta = {
    description = "ASCII art graphics library";
  };
}
