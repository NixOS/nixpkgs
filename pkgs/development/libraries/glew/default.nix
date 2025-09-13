{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  libGLU,
  libXmu,
  libXi,
  libXext,
  enableEGL ? (!stdenv.hostPlatform.isDarwin),
  testers,
  mesa,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glew";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/glew/glew-${finalAttrs.version}.tgz";
    sha256 = "1qak8f7g1iswgswrgkzc7idk7jmqgwrs58fhg2ai007v7j4q5z6l";
  };

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  patches = [
    # https://github.com/nigels-com/glew/pull/342
    (fetchpatch {
      url = "https://github.com/nigels-com/glew/commit/966e53fa153175864e151ec8a8e11f688c3e752d.diff";
      hash = "sha256-xsSwdAbdWZA4KVoQhaLlkYvO711i3QlHGtv6v1Omkhw=";
    })

    # don't make EGL support disable GLX, use the same patch as ArchLinux
    # https://gitlab.archlinux.org/archlinux/packaging/packages/glew/-/blob/ca08ff5d4cd3548a593eb1118d0a84b0c3670349/egl+glx.patch
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/glew/-/raw/ca08ff5d4cd3548a593eb1118d0a84b0c3670349/egl+glx.patch?inline=false";
      hash = "sha256-IG3FPhhaor1kshEH3Kr8yzIHqBhczRwCqH7ZeDwlzGE=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libXmu
    libXi
    libXext
  ];
  propagatedBuildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ libGLU ]; # GL/glew.h includes GL/glu.h

  cmakeDir = "cmake";
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ]
  ++ lib.optional enableEGL "-DGLEW_EGL=ON";

  postInstall = ''
    moveToOutput lib/cmake "''${!outputDev}"
    moveToOutput lib/pkgconfig "''${!outputDev}"

    cat >> "''${!outputDev}"/lib/cmake/glew/glew-config.cmake <<EOF
    # nixpkg's workaround for a cmake bug
    # https://discourse.cmake.org/t/the-findglew-cmake-module-does-not-set-glew-libraries-in-some-cases/989/3
    set(GLEW_VERSION "$version")
    set(GLEW_LIBRARIES GLEW::glew\''${_glew_target_postfix})
    get_target_property(GLEW_INCLUDE_DIRS GLEW::glew\''${_glew_target_postfix} INTERFACE_INCLUDE_DIRECTORIES)
    set_target_properties(GLEW::GLEW\''${_glew_target_postfix} PROPERTIES
        IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE ""
        IMPORTED_IMPLIB_RELEASE "GLEW"
        IMPORTED_IMPLIB_DEBUG "GLEW"
    )
    EOF
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "OpenGL extension loading library for C/C++";
    homepage = "https://glew.sourceforge.net/";
    license = with licenses; [
      # modified bsd
      free
      mit
      gpl2Only
    ]; # For full details, see https://github.com/nigels-com/glew#copyright-and-licensing
    pkgConfigModules = [ "glew" ];
    platforms =
      with platforms;
      if enableEGL then subtractLists darwin mesa.meta.platforms else mesa.meta.platforms;
  };
})
