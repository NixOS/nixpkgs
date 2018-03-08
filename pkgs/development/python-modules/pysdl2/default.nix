{ stdenv, lib, fetchPypi, buildPythonPackage, fetchurl, SDL2, SDL2_ttf, SDL2_image, SDL2_gfx, SDL2_mixer, pyopengl }:

buildPythonPackage rec {
  pname = "PySDL2";
  version = "0.9.6";
  # The tests use OpenGL using find_library, which would have to be
  # patched; also they seem to actually open X windows and test stuff
  # like "screensaver disabling", which would have to be cleverly
  # sandboxed. Disable for now.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "08r1v9wdq8pzds4g3sng2xgh1hlzfs2z7qgy5a6b0xrs96swlamm";
  };

  # Deliberately not in propagated build inputs; users can decide
  # which library they want to include.
  buildInputs = [ SDL2_ttf SDL2_image SDL2_gfx SDL2_mixer ];
  propagatedBuildInputs = [ SDL2 ];
  patches = [ ./PySDL2-dll.patch ];
  postPatch = ''
    substituteInPlace sdl2/dll.py --replace \
      "DLL(\"SDL2\")" "DLL('${SDL2}/lib/libSDL2${stdenv.hostPlatform.extensions.sharedLibrary}')"
    substituteInPlace sdl2/sdlttf.py --replace \
      "DLL(\"SDL2_ttf\")" "DLL('${SDL2_ttf}/lib/libSDL2_ttf${stdenv.hostPlatform.extensions.sharedLibrary}')"
    substituteInPlace sdl2/sdlimage.py --replace \
      "DLL(\"SDL2_image\")" "DLL('${SDL2_image}/lib/libSDL2_image${stdenv.hostPlatform.extensions.sharedLibrary}')"
    substituteInPlace sdl2/sdlgfx.py --replace \
     "DLL(\"SDL2_gfx\")" "DLL('${SDL2_gfx}/lib/libSDL2_gfx${stdenv.hostPlatform.extensions.sharedLibrary}')"
    substituteInPlace sdl2/sdlmixer.py --replace \
     "DLL(\"SDL2_mixer\")" "DLL('${SDL2_mixer}/lib/libSDL2_mixer${stdenv.hostPlatform.extensions.sharedLibrary}')"
  '';

  meta = {
    description = "A wrapper around the SDL2 library and as such similar to the discontinued PySDL project";
    homepage = https://github.com/marcusva/py-sdl2;
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ pmiddend ];
  };
}
