{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gitUpdater,
  cmake,
  static ? stdenv.hostPlatform.isStatic,
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

  patches = [
    (fetchpatch {
      name = "yaml-cpp-fix-cmake-4.patch";
      url = "https://github.com/jbeder/yaml-cpp/commit/c2680200486572baf8221ba052ef50b58ecd816e.patch";
      hash = "sha256-1kXRa+xrAbLEhcJxNV1oGHPmayj1RNIe6dDWXZA3mUA=";
    })
    # Fix build with gcc15
    # https://github.com/jbeder/yaml-cpp/pull/1310
    (fetchpatch {
      name = "yaml-cpp-add-include-cstdint-gcc15.patch";
      url = "https://github.com/jbeder/yaml-cpp/commit/7b469b4220f96fb3d036cf68cd7bd30bd39e61d2.patch";
      hash = "sha256-4Mua6cYD8UR+fJfFeu0fdYVFprsiuF89HvbaTByz9nI=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DYAML_CPP_BUILD_TOOLS=false"
    (lib.cmakeBool "YAML_BUILD_SHARED_LIBS" (!static))
    "-DINSTALL_GTEST=false"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "YAML parser and emitter for C++";
    homepage = "https://github.com/jbeder/yaml-cpp";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
