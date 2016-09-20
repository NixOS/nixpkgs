{ stdenv, fetchurl, fixedPoint ? false, withCustomModes ? true }:

let
  version = "1.1.3";
in
stdenv.mkDerivation rec {
  name = "libopus-${version}";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/opus/opus-${version}.tar.gz";
    sha256 = "0cxnd7pjxbgh6l3cbzsw29phpr5cq28fikfhjlp1hc3y5s0gxdjq";
  };

  outputs = [ "out" "dev" ];

  configureFlags = stdenv.lib.optional fixedPoint "--enable-fixed-point"
                ++ stdenv.lib.optional withCustomModes "--enable-custom-modes";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Open, royalty-free, highly versatile audio codec";
    license = stdenv.lib.licenses.bsd3;
    homepage = http://www.opus-codec.org/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
