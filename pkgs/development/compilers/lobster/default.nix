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
  version = "unstable-2020-07-27";

  src = fetchFromGitHub {
    owner = "aardappel";
    repo = pname;
    rev = "9d68171494a79c83931426b624a0249a9c51882c";
    sha256 = "0d4gn71jym662i00rdmynv53ng1lgl81s5lw1sdddgn41wzs28dd";
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

