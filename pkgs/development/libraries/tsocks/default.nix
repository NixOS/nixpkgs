{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "tsocks-${version}";
  version = "1.8beta5";

  src = fetchurl {
    url = "mirror://sourceforge/tsocks/${name}.tar.gz";
    sha256 = "0ixkymiph771dcdzvssi9dr2pk1bzaw9zv85riv3xl40mzspx7c4";
  };

  patches = [ ./poll.patch ];

  preConfigure = ''
    sed -i -e "s,\\\/usr,"$(echo $out|sed -e "s,\\/,\\\\\\\/,g")",g" tsocks
    substituteInPlace tsocks --replace /usr $out
    export configureFlags="$configureFlags --libdir=$out/lib"
  '';

  meta = with stdenv.lib; {
    description = "Transparent SOCKS v4 proxying library";
    homepage = http://tsocks.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}