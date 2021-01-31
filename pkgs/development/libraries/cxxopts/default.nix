{ cmake, fetchFromGitHub, icu, lib, pkg-config, stdenv, enableUnicodeHelp ? true }:

stdenv.mkDerivation rec {
  name = "cxxopts";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "jarro2783";
    repo = name;
    rev = "v${version}";
    sha256 = "0d3y747lsh1wkalc39nxd088rbypxigm991lk3j91zpn56whrpha";
  };

  buildInputs = lib.optional enableUnicodeHelp [ icu.dev ];
  cmakeFlags = lib.optional enableUnicodeHelp [ "-DCXXOPTS_USE_UNICODE_HELP=TRUE" ];
  nativeBuildInputs = [ cmake ] ++ lib.optional enableUnicodeHelp [ pkg-config ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/jarro2783/cxxopts";
    description = "Lightweight C++ GNU-style option parser library";
    license = licenses.mit;
    maintainers = [ maintainers.spease ];
    platforms = platforms.all;
  };
}
