{stdenv, fetchurl, ncurses, automake}:

stdenv.mkDerivation {
  name = "aalib-1.4rc5";

  src = fetchurl {
    url = mirror://sourceforge/aa-project/aalib-1.4rc5.tar.gz;
    sha256 = "1vkh19gb76agvh4h87ysbrgy82hrw88lnsvhynjf4vng629dmpgv";
  };

  outputs = [ "bin" "dev" "out" "man" "info" ];
  setOutputFlags = false; # Doesn't support all the flags

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./darwin.patch ];

  # The fuloong2f is not supported by aalib still
  preConfigure = ''
    cp ${automake}/share/automake*/config.{sub,guess} .
    configureFlagsArray+=(
      "--bindir=$bin/bin"
      "--includedir=$dev/include"
      "--libdir=$out/lib"
    )
  '';

  buildInputs = [ ncurses ];

  configureFlags = [ "--without-x" "--with-ncurses=${ncurses.dev}" ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/aalib-config $dev/bin/aalib-config
    substituteInPlace $out/lib/libaa.la --replace "${ncurses.dev}/lib" "${ncurses.out}/lib"
  '';

  meta = {
    description = "ASCII art graphics library";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.lgpl2;
  };
}
