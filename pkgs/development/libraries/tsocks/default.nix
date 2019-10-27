{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "tsocks";
  version = "1.8beta5";

  src = fetchurl {
    url = "mirror://sourceforge/tsocks/${pname}-${version}.tar.gz";
    sha256 = "0ixkymiph771dcdzvssi9dr2pk1bzaw9zv85riv3xl40mzspx7c4";
  };

  patches = [ ./poll.patch ];

  preConfigure = ''
    sed -i -e "s,\\\/usr,"$(echo $out|sed -e "s,\\/,\\\\\\\/,g")",g" tsocks
    substituteInPlace tsocks --replace /usr $out
    export configureFlags="$configureFlags --libdir=$out/lib"
  '';

  preBuild = ''
    # We don't need the saveme binary, it is in fact never stored and we're
    # never injecting stuff into ld.so.preload anyway
    sed -i \
      -e "s,TARGETS=\(.*\)..SAVE.\(.*\),TARGETS=\1\2," \
      -e "/SAVE/d" Makefile
  '';

  meta = with stdenv.lib; {
    description = "Transparent SOCKS v4 proxying library";
    homepage = http://tsocks.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ edwtjo phreedom ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
