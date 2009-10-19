{stdenv, fetchurl, bison, pkgconfig, glib, gettext, perl}:

stdenv.mkDerivation {
  name = "mono-2.4.2.1";
  src = fetchurl {
    url = http://ftp.novell.com/pub/mono/sources/mono/mono-2.4.2.1.tar.bz2;
    sha256 = "0cbg29fz5xnyjmznwzsmaxrr0cxqisyxk7jx7m56p3zzr379f0f5";
  };

  buildInputs = [bison pkgconfig glib gettext perl];
  propagatedBuildInputs = [glib];

  NIX_LDFLAGS = "-lgcc_s" ;

  preBuild = "
    makeFlagsArray=(INSTALL=`type -tp install`)
    patchShebangs ./
  ";
}
