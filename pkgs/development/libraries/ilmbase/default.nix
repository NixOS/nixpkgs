{ stdenv, openexr, automake, autoconf, libtool, which }:

stdenv.mkDerivation {
  name = "ilmbase-${openexr.source.version}";
  
  src = openexr.source.src;

  prePatch = ''
    cd IlmBase
  '';

  preConfigure = ''
    ./bootstrap
  '';

  buildInputs = [ automake autoconf libtool which ];

  patches = [ ./bootstrap.patch ];

  meta = with stdenv.lib; {
    homepage = http://www.openexr.com/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
