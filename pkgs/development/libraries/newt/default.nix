{ fetchurl, stdenv, slang, popt }:

stdenv.mkDerivation rec {
  name = "newt-0.52.15";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/n/e/newt/${name}.tar.gz";
    sha256 = "0hg2l0siriq6qrz6mmzr6l7rpl40ay56c8cak87rb2ks7s952qbs";
  };

  patchPhase = ''
    sed -i -e s,/usr/bin/install,install, -e s,-I/usr/include/slang,, Makefile.in po/Makefile
  '';

  buildInputs = [ slang popt ];

  NIX_LDFLAGS = "-lncurses";

  preConfigure = ''
    # If CPP is set explicitly, configure and make will not agree about which
    # programs to use at different stages.
    unset CPP
  '';

  crossAttrs = {
    makeFlags = "CROSS_COMPILE=${stdenv.cc.prefix}";
  };

  meta = with stdenv.lib; {
    homepage = https://fedorahosted.org/newt/;
    description = "Library for color text mode, widget based user interfaces";

    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.viric ];
  };
}
