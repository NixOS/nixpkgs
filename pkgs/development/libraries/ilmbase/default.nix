{ stdenv, openexr, automake, autoconf, libtool }:

stdenv.mkDerivation {
  name = "ilmbase-${openexr.source.version}";
  
  src = openexr.source.src;

  prePatch = ''
    cd IlmBase
  '';

  preConfigure = ''
    ./bootstrap
  '';

  buildInputs = [ automake autoconf libtool ];

  meta = with stdenv.lib; {
    homepage = http://www.openexr.com/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
