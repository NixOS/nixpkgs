{ stdenv, fetchurl, boost, pkgconfig, librevenge, zlib }:

let version = "0.4.2"; in
stdenv.mkDerivation rec {
  name = "libwps-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/libwps/${name}.tar.gz";
    sha256 = "0c90i3zafxxsj989bd9bs577blx3mrb90rj52iv6ijc4qivi4wkr";
  };

  buildInputs = [ boost pkgconfig librevenge zlib ];

  meta = with stdenv.lib; {
    inherit version;
    homepage = http://libwps.sourceforge.net/;
    description = "Microsoft Works file word processor format import filter library";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
