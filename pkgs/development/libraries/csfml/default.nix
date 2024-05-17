{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sfml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csfml";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "CSFML";
    rev = finalAttrs.version;
    hash = "sha256-wwDHuyh4zMi0XCjIK7dUWiscPA+r8zLEvomuul6nlyQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sfml ];
  cmakeFlags = [
    "-DCMAKE_MODULE_PATH=${sfml}/share/SFML/cmake/Modules/"
    "-DCSFML_PKGCONFIG_INSTALL_PREFIX=share/pkgconfig"
  ];

  meta = {
    homepage = "https://www.sfml-dev.org/";
    description = "Simple and fast multimedia library";
    longDescription = ''
      SFML is a simple, fast, cross-platform and object-oriented multimedia API.
      It provides access to windowing, graphics, audio and network.
      It is written in C++, and has bindings for various languages such as C, .Net, Ruby, Python.
    '';
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ jpdoyle ];
    platforms = lib.platforms.linux;
  };
})
