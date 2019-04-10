{stdenv, fetchFromGitHub, cmake, libGL, libX11, libXext
, cf-private, Cocoa, AudioToolbox, OpenGL, Foundation, ForceFeedback
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "lobster";
  version = "unstable-2019-04-07";
  src = fetchFromGitHub {
    owner = "aardappel";
    repo = "lobster";
    rev = "d439dac87d9173859b44575ccd8898a4219cf926";
    sha256 = "0w9zn5xnw3y97qlfs5sakl1rbjbrwwjcjgahydp98l1a77h55ad3";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = optionals (!stdenv.isDarwin) [ libGL libX11 libXext ]
    ++ optionals stdenv.isDarwin [
    cf-private Cocoa AudioToolbox OpenGL Foundation ForceFeedback
    ];
  sourceRoot = "source/dev";
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'CMAKE_RUNTIME_OUTPUT_DIRECTORY' 'XCMAKE_RUNTIME_OUTPUT_DIRECTORY' \
      --replace 'install' 'xinstall'
    substituteInPlace src/platform.cpp \
      --replace "/usr/share/lobster/" "$out/share/lobster/" \
      --replace "#ifdef __linux__" "#if defined __linux__ || defined __APPLE__ "
  '';
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DVIDEO_VULKAN=OFF"
  ];
  installPhase = ''
    install -d $out/bin
    cp lobster $out/bin/
    install -d $out/share/lobster
    for i in data docs modules samples shaders tests
    do
      cp -R $src/lobster/$i $out/share/lobster
    done
  '';
  enableParallelBuilding = true;
  meta = {
    homepage = http://strlen.com/lobster;
    description = "The Lobster programming language";
    license = licenses.asl20 ;
  };
}
