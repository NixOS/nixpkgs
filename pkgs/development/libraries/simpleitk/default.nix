{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  swig,
  lua,
  elastix,
  itk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simpleitk";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "SimpleITK";
    repo = "SimpleITK";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9EJwdF0ja1GuMJ7HU3Xg2IHyz/zWSsS1JdWrvla61HI=";
  };

  nativeBuildInputs = [
    cmake
    swig
  ];
  buildInputs = [
    elastix
    lua
    itk
  ];

  # 2.0.0: linker error building examples
  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_SHARED_LIBS=OFF"
    "-DSimpleITK_USE_ELASTIX=ON"
  ];

  meta = {
    homepage = "https://www.simpleitk.org";
    description = "Simplified interface to ITK";
    changelog = "https://github.com/SimpleITK/SimpleITK/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.asl20;
  };
})
