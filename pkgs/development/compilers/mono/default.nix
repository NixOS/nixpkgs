{stdenv, fetchurl, bison, pkgconfig, glib, gettext, perl}:

stdenv.mkDerivation {
  name = "mono-2.8";
  src = fetchurl {
    url = http://ftp.novell.com/pub/mono/sources/mono/mono-2.8.tar.bz2;
    sha256 = "04bivxg90mmihkp72sjshl4ijbjcbl9f6hdgm476zy794g5rwd78";
  };

  buildInputs = [bison pkgconfig glib gettext perl];
  propagatedBuildInputs = [glib];

  NIX_LDFLAGS = "-lgcc_s" ;

  # To overcome the bug https://bugzilla.novell.com/show_bug.cgi?id=644723
  dontDisableStatic = true;

  # Attempt to fix this error when running "mcs --version":
  # The file /nix/store/xxx-mono-2.4.2.1/lib/mscorlib.dll is an invalid CIL image
  dontStrip = true;

  enableParallelBuilding = true;

  preBuild = "
    makeFlagsArray=(INSTALL=`type -tp install`)
    patchShebangs ./
  ";
}
