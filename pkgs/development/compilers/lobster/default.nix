{ lib, stdenv
, fetchFromGitHub
, unstableGitUpdater
, cmake
, callPackage

# Linux deps
, libGL
, xorg

# Darwin deps
, cf-private
, Cocoa
, AudioToolbox
, OpenGL
, Foundation
, ForceFeedback
}:

stdenv.mkDerivation rec {
  pname = "lobster";
  version = "unstable-2020-12-25";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = pname;
    rev = "70e44d475995b03363dedf9c2bcb817b0db8fdcf";
    sha256 = "0azhminzrkbpvkapass1kccd6123bg7qmcbnzr5774n6bz5365g3";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = if stdenv.isDarwin
    then [
      cf-private
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

  preConfigure = "cd dev";

  passthru = {
    tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix {};
    updateScript = unstableGitUpdater {
      url = "https://github.com/aardappel/lobster";
    };
  };

  meta = with lib; {
    homepage = "http://strlen.com/lobster";
    description = "The Lobster programming language";
    longDescription = ''
      Lobster is a programming language that tries to combine the advantages of
      very static typing and memory management with a very lightweight,
      friendly and terse syntax, by doing most of the heavy lifting for you.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
