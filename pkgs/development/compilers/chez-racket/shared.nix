args:
{ stdenv, lib, fetchFromGitHub, coreutils, cctools, darwin
, ncurses, libiconv, libX11, zlib, lz4
}:

stdenv.mkDerivation (args // {
  version = "unstable-2021-12-11";

  src = fetchFromGitHub {
    owner  = "racket";
    repo   = "ChezScheme";
    rev    = "8846c96b08561f05a937d5ecfe4edc96cc99be39";
    sha256 = "IYJQzT88T8kFahx2BusDOyzz6lQDCbZIfSz9rZoNF7A=";
    fetchSubmodules = true;
  };

  prePatch = ''
    rm -rf zlib/*.c lz4/lib/*.c
  '';

  postPatch = ''
    export ZLIB="$(find ${zlib.out}/lib -type f | sort | head -n1)"
    export LZ4="$(find ${lz4.out}/lib -type f | sort | head -n1)"
  '';

  nativeBuildInputs = lib.optionals stdenv.isDarwin ([ cctools darwin.autoSignDarwinBinariesHook ]);
  buildInputs = [ libiconv libX11 lz4 ncurses zlib ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=format-truncation";

  meta = {
    description  = "Fork of Chez Scheme for Racket";
    homepage     = "https://github.com/racket/ChezScheme";
    license      = lib.licenses.asl20;
    maintainers  = with lib.maintainers; [ l-as ];
    platforms    = lib.platforms.unix;
  };
})
