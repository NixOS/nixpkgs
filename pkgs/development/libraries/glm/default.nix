{ stdenv, fetchzip, cmake }:

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

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '"''${CMAKE_CURRENT_BINARY_DIR}/''${GLM_INSTALL_CONFIGDIR}' '"''${GLM_INSTALL_CONFIGDIR}'
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

