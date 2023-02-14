{ lib
, stdenv
, fetchFromGitHub
, cmake
, cpm-cmake
, package-project-cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glob-cpp";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "p-ranav";
    repo = "glob";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2y+a7YFBiYX8wbwCCWw1Cm+SFoXGB3ZxLPi/QdZhcdw=";
  };

  preConfigure = ''
    mkdir -p ${placeholder "out"}/share/cpm
    cp ${cpm-cmake}/share/cpm/CPM.cmake ${placeholder "out"}/share/cpm/CPM_0.27.2.cmake
  '';

  cmakeFlags = [
    "-Hall"
    "-DCPM_SOURCE_CACHE=${placeholder "out"}/share"
    "-DFETCHCONTENT_SOURCE_DIR_PACKAGEPROJECT.CMAKE=${package-project-cmake.src}"
  ];

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    package-project-cmake
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    ./build/standalone/glob -r -i "**/*.hpp"

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/p-ranav/glob";
    description = "Glob for C++17";
    license = licenses.mit;
    maintainers = with maintainers; [ ken-matsui ];
    platforms = platforms.unix;
  };
})
