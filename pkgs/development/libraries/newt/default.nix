{ fetchurl, stdenv, slang, popt }:

stdenv.mkDerivation rec {
  pname = "newt";
  version = "0.52.21";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/n/e/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0cdvbancr7y4nrj8257y5n45hmhizr8isynagy4fpsnpammv8pi6";
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

  makeFlags = stdenv.lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  meta = with stdenv.lib; {
    homepage = "https://fedorahosted.org/newt/";
    description = "Library for color text mode, widget based user interfaces";

    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.viric ];
  };
}
