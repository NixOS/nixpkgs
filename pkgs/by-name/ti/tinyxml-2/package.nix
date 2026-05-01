{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinyxml2";
  version = "11.0.0";

  src = fetchFromGitHub {
    owner = "leethomason";
    repo = "tinyxml2";
    rev = finalAttrs.version;
    hash = "sha256-rYVQSvxA0nxlZFHwGcOWkxcXZWEvTxR9P+d8E7CSm6U=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR
    # correctly (setting it to an absolute path causes include files to go to
    # $out/$out/include, because the absolute path is interpreted with root at
    # $out).
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = {
    description = "Simple, small, efficient, C++ XML parser";
    homepage = "https://github.com/leethomason/tinyxml2";
    changelog = "https://github.com/leethomason/tinyxml2/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [ zlib ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
