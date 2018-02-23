{ stdenv, fetchurl, fetchzip, cmake }:

stdenv.mkDerivation rec {
  version = "0.9.8.5";
  name = "glm-${version}";

  src = fetchzip {
    url = "https://github.com/g-truc/glm/releases/download/${version}/${name}.zip";
    sha256 = "0dkfj4hin3am9fxgcvwr5gj0h9y52x7wa03lfwb3q0bvaj1rsly2";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "doc" ];

  cmakeConfigureFlags = [ "-DGLM_INSTALL_ENABLE=off" ];

  # fetch newer version of platform.h which correctly supports gcc 7.3
  gcc7PlatformPatch = fetchurl {
    url = "https://raw.githubusercontent.com/g-truc/glm/dd48b56e44d699a022c69155c8672caacafd9e8a/glm/simd/platform.h";
    sha256 = "0y91hlbgn5va7ijg5mz823gqkq9hqxl00lwmdwnf8q2g086rplzw";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '"''${CMAKE_CURRENT_BINARY_DIR}/''${GLM_INSTALL_CONFIGDIR}' '"''${GLM_INSTALL_CONFIGDIR}'
    cp ${gcc7PlatformPatch} glm/simd/platform.h
  '';

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
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}

