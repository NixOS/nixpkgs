{ stdenv, lib, fetchurl, pkgconfig, libcdio, libxml2, popt
, libiconv, darwin }:

stdenv.mkDerivation rec {
  name = "vcdimager-2.0.1";

  src = fetchurl {
    url = "mirror://gnu/vcdimager/${name}.tar.gz";
    sha256 = "0ypnb1vp49nmzp5571ynlz6n1gh90f23w3z4x95hb7c2p7pmylb7";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libxml2 popt libiconv ]
             ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ IOKit DiskArbitration ]);

  propagatedBuildInputs = [ libcdio ];

  meta = with lib; {
    homepage = https://www.gnu.org/software/vcdimager/;
    description = "Full-featured mastering suite for authoring, disassembling and analyzing Video CDs and Super Video CDs";
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
