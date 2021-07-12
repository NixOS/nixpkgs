{ cmake, fetchFromGitHub, icu, lib, pkg-config, stdenv, enableUnicodeHelp ? true }:

stdenv.mkDerivation rec {
  name = "cxxopts";
  version = "unstable-2020-12-14";

  src = fetchFromGitHub {
    owner = "jarro2783";
    repo = name;
    rev = "2d8e17c4f88efce80e274cb03eeb902e055a91d3";
    sha256 = "0pwrac81zfqjs17g3hx8r3ds2xf04npb6mz111qjy4bx17314ib7";
  };

  buildInputs = lib.optional enableUnicodeHelp [ icu.dev ];
  cmakeFlags = [ "-DCXXOPTS_BUILD_EXAMPLES=OFF" ]
    ++ lib.optional enableUnicodeHelp "-DCXXOPTS_USE_UNICODE_HELP=TRUE"
    # Due to -Wsuggest-override, remove when cxxopts is updated
    ++ lib.optional stdenv.isDarwin "-DCXXOPTS_ENABLE_WARNINGS=OFF";
  nativeBuildInputs = [ cmake ] ++ lib.optional enableUnicodeHelp [ pkg-config ];

  doCheck = true;

  # Conflict on case-insensitive filesystems.
  dontUseCmakeBuildDir = true;

  meta = with lib; {
    homepage = "https://github.com/jarro2783/cxxopts";
    description = "Lightweight C++ GNU-style option parser library";
    license = licenses.mit;
    maintainers = [ maintainers.spease ];
    platforms = platforms.all;
  };
}
