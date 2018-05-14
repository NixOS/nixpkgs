{ stdenv, fetchurl, cmake, ninja, unzip }:

stdenv.mkDerivation rec {
  version = "6.4.2";
  name = "Clipper-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/polyclipping/clipper_ver${version}.zip";
    sha256 = "09q6jc5k7p9y5d75qr2na5d1gm0wly5cjnffh127r04l47c20hx1";
  };

  sourceRoot = "cpp";

  buildInputs = [ ];

  nativeBuildInputs = [ cmake ninja unzip ];

  meta = with stdenv.lib; {
    longDescription = ''
      The Clipper library performs line & polygon clipping - intersection, union, difference & exclusive-or,
      and line & polygon offsetting. The library is based on Vatti's clipping algorithm.
    '';
    homepage = https://www.angusj.com/delphi/clipper.php;
    license = licenses.boost;
    maintainers = with maintainers; [ mpickering ];
    platforms = with platforms; unix;
  };
}
