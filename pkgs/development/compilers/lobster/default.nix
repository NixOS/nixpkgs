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
  version = "2021.3";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "lobster";
    rev = "v${version}";
    sha256 = "sha256-ENs2Jy2l6fogZdCSaIyfV9wQm57qaZfx5HVHOnQBrRk=";
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

  preConfigure = ''
    cd dev
  '';

  passthru.tests.can-run-hello-world = callPackage ./test-can-run-hello-world.nix {};

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://strlen.com/lobster/";
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
