{stdenv, fetchurl, bison, pkgconfig, glib, gettext, perl, libgdiplus}:

stdenv.mkDerivation {
  name = "mono-2.10.8.1";
  src = fetchurl {
    url = http://download.mono-project.com/sources/mono/mono-2.10.8.1.tar.gz;
    sha256 = "0h4hdj99qg0nsg5260izwaybs59wysf7y399kffhg43fidpndz0x";
  };

  buildInputs = [bison pkgconfig glib gettext perl libgdiplus];
  propagatedBuildInputs = [glib];

  NIX_LDFLAGS = "-lgcc_s" ;

  # To overcome the bug https://bugzilla.novell.com/show_bug.cgi?id=644723
  dontDisableStatic = true;

  configureFlags = "--with-libgdiplus=${libgdiplus}/lib/libgdiplus.so";

  # Attempt to fix this error when running "mcs --version":
  # The file /nix/store/xxx-mono-2.4.2.1/lib/mscorlib.dll is an invalid CIL image
  dontStrip = true;

  enableParallelBuilding = true;

  preBuild = "
    makeFlagsArray=(INSTALL=`type -tp install`)
    patchShebangs ./
  ";
}
