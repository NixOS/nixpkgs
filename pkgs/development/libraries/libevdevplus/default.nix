{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libevdevplus";
  version = "unstable-2019-10-01";

  src  = fetchFromGitHub {
    owner  = "YukiWorkshop";
    repo   = "libevdevPlus";
    rev    = "e863df2ade43e2c7d7748cc33ca27fb3eed325ca";
    sha256 = "18z6pn4j7fhmwwh0q22ip5nn7sc1hfgwvkdzqhkja60i8cw2cvvj";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Easy-to-use event device library in C++";
    license = licenses.mit;
    maintainers = with maintainers; [ willibutz ];
    platforms = with platforms; linux;
  };
}
