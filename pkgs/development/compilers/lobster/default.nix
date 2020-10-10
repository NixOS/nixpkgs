{ stdenv
, fetchFromGitHub
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
  version = "unstable-2020-10-04";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = pname;
    rev = "4c5e78f021ce9d06592fb3a66388e5e31fac1adb";
    sha256 = "1wnbc8kr1dyfs53nlcxah22ghphmazzrlcj9z47cgkdsj1qfy84x";
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
  enableParallelBuilding = true;

  passthru.tests = {
    can-run-hello-world = callPackage ./test-can-run-hello-world.nix {};
  };

  meta = with stdenv.lib; {
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

