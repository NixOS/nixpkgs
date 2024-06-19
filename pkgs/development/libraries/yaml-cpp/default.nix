{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
, cmake
}:

stdenv.mkDerivation rec {
  pname = "yaml-cpp";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = version;
    hash = "sha256-J87oS6Az1/vNdyXu3L7KmUGWzU0IAkGrGMUUha+xDXI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DYAML_CPP_BUILD_TOOLS=false"
    "-DYAML_BUILD_SHARED_LIBS=${lib.boolToString (!stdenv.hostPlatform.isStatic)}"
    "-DINSTALL_GTEST=false"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A YAML parser and emitter for C++";
    homepage = "https://github.com/jbeder/yaml-cpp";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
