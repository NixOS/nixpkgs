{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "yaml-cpp_0_3";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jbeder";
    repo = "yaml-cpp";
    rev = "release-${version}";
    hash = "sha256-pmgcULTXhl83+Wc8ZsGebnJ1t0XybHhUEJxDnEZE5x8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DYAML_CPP_BUILD_TOOLS=${lib.boolToString doCheck}"
    "-DBUILD_SHARED_LIBS=${lib.boolToString (!stdenv.hostPlatform.isStatic)}"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "cmake_policy(SET CMP0015 OLD)" "cmake_policy(SET CMP0015 NEW)" \
      --replace-fail "cmake_policy(SET CMP0012 OLD)" "cmake_policy(SET CMP0012 NEW)"
  '';

  meta = with lib; {
    description = "YAML parser and emitter for C++";
    homepage = "https://github.com/jbeder/yaml-cpp";
    license = licenses.mit;
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ iedame ];
  };
}
