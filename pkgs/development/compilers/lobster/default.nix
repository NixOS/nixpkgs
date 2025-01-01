{ lib, stdenv
, fetchFromGitHub
, cmake
, callPackage

# Linux deps
, libGL
, xorg

# Darwin deps
, CoreFoundation
, Cocoa
, AudioToolbox
, OpenGL
, Foundation
, ForceFeedback
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lobster";
  version = "2024.0";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "lobster";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-EBgb442wI9qU/o6EVCwPnMtPuv1f6Xk2+CZpKWXf3tY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = if stdenv.hostPlatform.isDarwin
    then [
      CoreFoundation
      Cocoa
      AudioToolbox
      OpenGL
      Foundation
      ForceFeedback
    ]
    else [
      libGL
      xorg.libX11
      xorg.libXext
    ];

  preConfigure = ''
    cd dev
  '';

  passthru.tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix {};

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://strlen.com/lobster/";
    description = "Lobster programming language";
    mainProgram = "lobster";
    longDescription = ''
      Lobster is a programming language that tries to combine the advantages of
      very static typing and memory management with a very lightweight,
      friendly and terse syntax, by doing most of the heavy lifting for you.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
})
