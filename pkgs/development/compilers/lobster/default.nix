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
  version = "unstable-2021-06-18";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = pname;
    rev = "a785316e44b1690da56a3646f90971a72f470a49";
    sha256 = "eY/8mhJ4SUH5QYWqykl0u+8W7AU0FVVya3GNTEUSOP4=";
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
