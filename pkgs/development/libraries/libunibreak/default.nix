{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libunibreak";
  version = "4.3";

  src = let
      rev_version = lib.replaceStrings ["."] ["_"] version;
  in fetchFromGitHub {
    owner = "adah1972";
    repo = pname;
    rev = "libunibreak_${rev_version}";
    sha256 = "19g3ixs1ycisfdnzd8v7j5r49h0x0hshchk9qwlz4i0mjv825plx";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/adah1972/libunibreak";
    description = "Implementation of line breaking and word breaking algorithms as in the Unicode standard";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = [ maintainers.coroa ];
  };
}
