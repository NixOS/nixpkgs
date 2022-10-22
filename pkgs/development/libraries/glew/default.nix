{ lib, stdenv, fetchurl, fetchpatch, cmake, libGLU, xlibsWrapper, libXmu, libXi
, OpenGL
, enableEGL ? false
}:

stdenv.mkDerivation rec {
  pname = "glew";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/glew/${pname}-${version}.tgz";
    sha256 = "1qak8f7g1iswgswrgkzc7idk7jmqgwrs58fhg2ai007v7j4q5z6l";
  };

  outputs = [ "bin" "out" "dev" ];

  patches = [
    # https://github.com/nigels-com/glew/pull/342
    (fetchpatch {
      url = "https://github.com/nigels-com/glew/commit/966e53fa153175864e151ec8a8e11f688c3e752d.diff";
      sha256 = "sha256-xsSwdAbdWZA4KVoQhaLlkYvO711i3QlHGtv6v1Omkhw=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals (!stdenv.isDarwin) [ xlibsWrapper libXmu libXi ];
  propagatedBuildInputs = if stdenv.isDarwin then [ OpenGL ] else [ libGLU ]; # GL/glew.h includes GL/glu.h

  cmakeDir = "cmake";
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ lib.optional enableEGL "-DGLEW_EGL=ON";

  postInstall = ''
    moveToOutput lib/cmake "''${!outputDev}"
    moveToOutput lib/pkgconfig "''${!outputDev}"

    cat >> "''${!outputDev}"/lib/cmake/glew/glew-config.cmake <<EOF
    # nixpkg's workaround for a cmake bug
    # https://discourse.cmake.org/t/the-findglew-cmake-module-does-not-set-glew-libraries-in-some-cases/989/3
    set(GLEW_VERSION "$version")
    set(GLEW_LIBRARIES GLEW::glew\''${_glew_target_postfix})
    get_target_property(GLEW_INCLUDE_DIRS GLEW::glew\''${_glew_target_postfix} INTERFACE_INCLUDE_DIRECTORIES)
    EOF
  '';

  meta = with lib; {
    description = "An OpenGL extension loading library for C/C++";
    homepage = "http://glew.sourceforge.net/";
    license = with licenses; [ /* modified bsd */ free mit gpl2Only ]; # For full details, see https://github.com/nigels-com/glew#copyright-and-licensing
    platforms = with platforms;
      if enableEGL then
        subtractLists darwin mesaPlatforms
      else
        mesaPlatforms;
  };
}
