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
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "SimpleITK";
    repo = "SimpleITK";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aVYsb7i/DNnJ8327eO2MZ5LWz8moqE7rf2DIp4M3Q+M=";
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

  meta = with lib; {
    homepage = "https://www.simpleitk.org";
    description = "Simplified interface to ITK";
    changelog = "https://github.com/SimpleITK/SimpleITK/releases/tag/v${finalAttrs.version}";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
})
