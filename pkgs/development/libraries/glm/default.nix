{ stdenv, fetchurl, fetchzip, cmake }:

stdenv.mkDerivation rec {
  version = "0.9.8.5";
  pname = "glm";

  src = fetchzip {
    url = "https://github.com/g-truc/glm/releases/download/${version}/${pname}-${version}.zip";
    sha256 = "0dkfj4hin3am9fxgcvwr5gj0h9y52x7wa03lfwb3q0bvaj1rsly2";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "doc" ];

  cmakeConfigureFlags = [ "-DGLM_INSTALL_ENABLE=off" ];

  # fetch newer version of platform.h which correctly supports gcc 7.3
  gcc7PlatformPatch = fetchurl {
    url = "https://raw.githubusercontent.com/g-truc/glm/384dab02e45a8ad3c1a3fa0906e0d5682c5b27b9/glm/simd/platform.h";
    sha256 = "0ym0sgwznxhfyi014xs55x3ql7r65fjs34sqb5jiaffkdhkqgzia";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '"''${CMAKE_CURRENT_BINARY_DIR}/''${GLM_INSTALL_CONFIGDIR}' '"''${GLM_INSTALL_CONFIGDIR}'
    cp ${gcc7PlatformPatch} glm/simd/platform.h
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin "-DGLM_COMPILER=0";

  postInstall = ''
    mkdir -p $doc/share/doc/glm
    cp -rv $NIX_BUILD_TOP/$sourceRoot/doc/* $doc/share/doc/glm
  '';

  meta = with stdenv.lib; {
    description = "OpenGL Mathematics library for C++";
    longDescription = ''
      OpenGL Mathematics (GLM) is a header only C++ mathematics library for
      graphics software based on the OpenGL Shading Language (GLSL)
      specification and released under the MIT license.
    '';
    homepage = http://glm.g-truc.net/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}

