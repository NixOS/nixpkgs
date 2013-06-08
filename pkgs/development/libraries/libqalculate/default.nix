{ stdenv, fetchurl, cln, libxml2, glib, intltool, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libqalculate-0.9.7";

  src = fetchurl {
    url = "mirror://sourceforge/qalculate/${name}.tar.gz";
    sha256 = "0mbrc021dk0ayyglk4qyf9328cayrlz2q94lh8sh9l9r6g79fvcs";
  };

  buildInputs = [ intltool pkgconfig ];
  propagatedBuildInputs = [ cln libxml2 glib ];

  meta = {
    description = "An advanced calculator library";
    homepage = http://qalculate.sourceforge.net;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
