{ stdenv, fetchurl }:

with stdenv.lib;
stdenv.mkDerivation rec{
  srcName = "tcl${version}-src";
  name = "tcl-${version}";
  version = "8.6.4";

  src = fetchurl {
    url = "mirror://sourceforge/tcl/Tcl/${version}/${srcName}.tar.gz";
    sha256 = "13cwa4bc85ylf5gfj9vk182lvgy60qni3f7gbxghq78wk16djvly";
  };

  preConfigure = "cd unix";

  postInstall = ''
    make install-private-headers
    ln -s $out/bin/tclsh8.6 $out/bin/tclsh
  '';
  
  meta = {
    description = "The Tcl scripting language";
    homepage = http://www.tcl.tk/;
    maintainers = [ maintainers.AndersonTorres ];
    license = licenses.tcltk;
  };
  
  passthru = {
    libdir = "lib/tcl8.6";
  };
}
