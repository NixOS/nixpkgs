{ stdenv, callPackage, autoconf, automake, libtool, pkgconfig, zlib, ilmbase }:
let
  source = callPackage ./source.nix { };
in
stdenv.mkDerivation rec {
  name = "openexr-${source.version}";
  
  src = source.src;

  prePatch = ''
    cd OpenEXR
  '';

  preConfigure = ''
    ./bootstrap
  '';

  configureFlags = [ "--enable-imfexamples" ];
  
  buildInputs = [ autoconf automake libtool pkgconfig ];
  propagatedBuildInputs = [ ilmbase zlib ];
  
  meta = with stdenv.lib; {
    homepage = http://www.openexr.com/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };

  passthru.source = source;
}
