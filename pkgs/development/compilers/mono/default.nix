{stdenv, fetchurl, bison, pkgconfig, glib, gettext, perl, libgdiplus}:

stdenv.mkDerivation rec {
  name = "mono-2.11.4";
  src = fetchurl {
    url = "http://download.mono-project.com/sources/mono/${name}.tar.bz2";
    sha256 = "0wv8pnj02mq012sihx2scx0avyw51b5wb976wn7x86zda0vfcsnr";
  };

  buildInputs = [bison pkgconfig glib gettext perl libgdiplus];
  propagatedBuildInputs = [glib];

  NIX_LDFLAGS = "-lgcc_s" ;

  # To overcome the bug https://bugzilla.novell.com/show_bug.cgi?id=644723
  dontDisableStatic = true;

  # In fact I think this line does not help at all to what I
  # wanted to achieve: have mono to find libgdiplus automatically
  configureFlags = "--with-libgdiplus=${libgdiplus}/lib/libgdiplus.so";

  # Attempt to fix this error when running "mcs --version":
  # The file /nix/store/xxx-mono-2.4.2.1/lib/mscorlib.dll is an invalid CIL image
  dontStrip = true;

  # Parallel building doesn't work, as shows http://hydra.nixos.org/build/2983601
  enableParallelBuilding = false;

  preBuild = "
    makeFlagsArray=(INSTALL=`type -tp install`)
    patchShebangs ./
  ";

  meta = {
    homepage = http://mono-project.com/;
    description = "Cross platform, open source .NET development framework";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
    license = "free"; # Combination of LGPL/X11/GPL ?
  };
}
