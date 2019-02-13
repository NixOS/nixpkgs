{ stdenv, callPackage, cmake, pkgconfig, ilmbase, libtiff, openexr }:

let
  source = callPackage ./source.nix { };
in
stdenv.mkDerivation {
  name = "ctl-${source.version}";

  src = source.src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake libtiff ilmbase openexr ];

  meta = with stdenv.lib; {
    description = "Color Transformation Language";
    homepage = http://ampasctl.sourceforge.net;
    license = "A.M.P.A.S";
    platforms = platforms.all;
  };

  passthru.source = source;
}
