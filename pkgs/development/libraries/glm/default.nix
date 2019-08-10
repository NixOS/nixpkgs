{ stdenv, fetchurl, fetchzip, cmake }:

stdenv.mkDerivation rec {
  version = "0.9.9.5";
  name = "glm-${version}";

  src = fetchzip {
    url = "https://github.com/g-truc/glm/releases/download/${version}/${name}.zip";
    sha256 = "1rn875y5fqqr350w05bbvd5cbhzq90nbqlv1bcrm9664pih2glm5";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "doc" ];

  cmakeConfigureFlags = [ "-DGLM_INSTALL_ENABLE=off" ];

  # fetch newer version of platform.h which correctly supports gcc 7.3

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '"''${CMAKE_CURRENT_BINARY_DIR}/''${GLM_INSTALL_CONFIGDIR}' '"''${GLM_INSTALL_CONFIGDIR}'
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionals stdenv.isDarwin [
    "-DGLM_COMPILER=0"
  ];

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

