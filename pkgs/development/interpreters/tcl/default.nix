{ stdenv, fetchurl }:
let
  release = "8.6";
in
stdenv.mkDerivation rec {
  name = "tcl-${version}";
  version = "${release}.4";

  src = fetchurl {
    url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
    sha256 = "13cwa4bc85ylf5gfj9vk182lvgy60qni3f7gbxghq78wk16djvly";
  };

  preConfigure = "cd unix";

  postInstall = ''
    make install-private-headers
    ln -s $out/bin/tclsh${release} $out/bin/tclsh
  '';
  
  meta = with stdenv.lib; {
    description = "The Tcl scription language";
    homepage = http://www.tcl.tk/;
    license = licenses.tcltk;
    platforms = platforms.all;
  };
  
  passthru = rec {
    inherit release version;
    libPrefix = "tcl${release}";
    libdir = "lib/${libPrefix}";
  };
}
