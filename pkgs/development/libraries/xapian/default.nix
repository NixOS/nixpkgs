{ stdenv, fetchurl, libuuid, zlib }:

let
  generic = version: sha256: stdenv.mkDerivation rec {
    name = "xapian-${version}";

    src = fetchurl {
      url = "http://oligarchy.co.uk/xapian/${version}/xapian-core-${version}.tar.xz";
      inherit sha256;
    };

    outputs = [ "out" "doc" ];

    buildInputs = [ libuuid zlib ];

    meta = {
      description = "Search engine library";
      homepage = http://xapian.org/;
      license = stdenv.lib.licenses.gpl2Plus;
      maintainers = [ stdenv.lib.maintainers.chaoflow ];
      platforms = stdenv.lib.platforms.unix;
    };
  };
in {
  # used by xapian-ruby
  xapian_1_2_22 = generic "1.2.22" "0zsji22n0s7cdnbgj0kpil05a6bgm5cfv0mvx12d8ydg7z58g6r6";
  xapian_1_4_0 = generic "1.4.0" "0xv4da5rmqqzkkkzx2v3jwh5hz5zxhd2b7m8x30fk99a25blyn0h";
}
