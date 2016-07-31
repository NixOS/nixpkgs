{ stdenv, fetchurl

# Version specific stuff
, release, version, src
, ...
}:

stdenv.mkDerivation rec {
  name = "tcl-${version}";

  inherit src;

  preConfigure = ''
    cd unix
  '';

  postInstall = ''
    make install-private-headers
    ln -s $out/bin/tclsh${release} $out/bin/tclsh
  '';
  
  meta = with stdenv.lib; {
    description = "The Tcl scription language";
    homepage = http://www.tcl.tk/;
    license = licenses.tcltk;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington vrthra ];
  };
  
  passthru = rec {
    inherit release version;
    libPrefix = "tcl${release}";
    libdir = "lib/${libPrefix}";
  };
}
