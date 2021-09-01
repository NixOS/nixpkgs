{ stdenv, lib, substituteAll, fetchPypi, buildPythonPackage, SDL2, SDL2_ttf, SDL2_image, SDL2_gfx, SDL2_mixer }:

buildPythonPackage rec {
  pname = "PySDL2";
  version = "0.9.8";
  # The tests use OpenGL using find_library, which would have to be
  # patched; also they seem to actually open X windows and test stuff
  # like "screensaver disabling", which would have to be cleverly
  # sandboxed. Disable for now.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4dfa3168e4e4e9301a2cd5904bdcea15e2bf62a1c9abb5d3f92d9122ea22c26e";
  };

  # Deliberately not in propagated build inputs; users can decide
  # which library they want to include.
  buildInputs = [ SDL2_ttf SDL2_image SDL2_gfx SDL2_mixer ];
  propagatedBuildInputs = [ SDL2 ];
  patches = [
    (substituteAll ({
      src = ./PySDL2-dll.patch;
    } // builtins.mapAttrs (_: pkg: "${pkg}/lib/lib${pkg.pname}${stdenv.hostPlatform.extensions.sharedLibrary}") {
      # substituteAll keys must start lowercase
      sdl2 = SDL2;
      sdl2_ttf = SDL2_ttf;
      sdl2_image = SDL2_image;
      sdl2_gfx = SDL2_gfx;
      sdl2_mixer = SDL2_mixer;
    }))
  ];

  meta = {
    description = "A wrapper around the SDL2 library and as such similar to the discontinued PySDL project";
    homepage = "https://github.com/marcusva/py-sdl2";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ pmiddend ];
  };
}
