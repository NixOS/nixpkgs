{stdenv, fetchurl, bison, pkgconfig, glib, gettext, perl, libgdiplus, libX11}:

stdenv.mkDerivation rec {
  name = "mono-2.11.4";
  src = fetchurl {
    url = "http://download.mono-project.com/sources/mono/${name}.tar.bz2";
    sha256 = "0wv8pnj02mq012sihx2scx0avyw51b5wb976wn7x86zda0vfcsnr";
  };

  buildInputs = [bison pkgconfig glib gettext perl libgdiplus libX11];
  propagatedBuildInputs = [glib];

  NIX_LDFLAGS = "-lgcc_s" ;

  # To overcome the bug https://bugzilla.novell.com/show_bug.cgi?id=644723
  dontDisableStatic = true;

  # In fact I think this line does not help at all to what I
  # wanted to achieve: have mono to find libgdiplus automatically
  configureFlags = "--x-includes=${libX11}/include --x-libraries=${libX11}/lib --with-libgdiplus=${libgdiplus}/lib/libgdiplus.so";

  # Attempt to fix this error when running "mcs --version":
  # The file /nix/store/xxx-mono-2.4.2.1/lib/mscorlib.dll is an invalid CIL image
  dontStrip = true;

  # Parallel building doesn't work, as shows http://hydra.nixos.org/build/2983601
  enableParallelBuilding = false;

  preBuild = "
    makeFlagsArray=(INSTALL=`type -tp install`)
    patchShebangs ./
  ";

  #Fix mono DLLMap so it can find libX11 and gdiplus to run winforms apps
  #Other items in the DLLMap may need to be pointed to their store locations, I don't think this is exhaustive
  #http://www.mono-project.com/Config_DllMap
  postBuild = ''
    find . -name 'config' -type f | while read i; do
        sed -i "s@libMonoPosixHelper.so@$out/lib/libMonoPosixHelper.so@g" $i
        sed -i "s@libX11.so.6@${libX11}/lib/libX11.so.6@g" $i
        sed -i '2 i\<dllmap dll="gdiplus.dll" target="${libgdiplus}/lib/libgdiplus.so" os="!windows"/>' $i
    done
  '';

  meta = {
    homepage = http://mono-project.com/;
    description = "Cross platform, open source .NET development framework";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
    license = "free"; # Combination of LGPL/X11/GPL ?
  };
}
