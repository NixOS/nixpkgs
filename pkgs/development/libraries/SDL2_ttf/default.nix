{ lib, stdenv, pkg-config, darwin, fetchurl, SDL2, freetype, harfbuzz, libGL, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "SDL2_ttf";
  version = "2.20.2";

  src = fetchurl {
    url = "https://www.libsdl.org/projects/SDL_ttf/release/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-ncce2TSHUhsQeixKnKa/Q/ti9r3dXCawVea5FBiiIFM=";
  };

  configureFlags = [ "--disable-harfbuzz-builtin" ]
    ++ lib.optionals stdenv.isDarwin [ "--disable-sdltest" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ SDL2 freetype harfbuzz ]
    ++ lib.optional (!stdenv.isDarwin) libGL
    ++ lib.optional stdenv.isDarwin darwin.libobjc;

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "Support for TrueType (.ttf) font files with Simple Directmedia Layer";
    platforms = platforms.unix;
    license = licenses.zlib;
    homepage = "https://github.com/libsdl-org/SDL_ttf";
    pkgConfigModules = [ "SDL2_ttf" ];
  };
})
