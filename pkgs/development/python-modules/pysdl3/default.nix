{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  python,
  buildPythonPackage,
  setuptools-scm,
  packaging,
  aiohttp,
  requests,

  # native dependencies
  sdl3,
  sdl3-ttf,
  sdl3-image,
}:
let
  version = "0.9.11b0";

  # Arranging these as normal derivations allows the updater to function while still allowing easy access to the fod via the `src` attribute.
  # They are placed in separate files since the update script will replace all instances of the old version string
  # in the file where the derivation is defined, and can only do one hash per version update.
  # They must be derivations with `version`, `pname`, and `src` since `gitUpdater` will error out if they do not have a `name`,
  # and will only update the `src` attribute's `hash` (and any other instances of the hash).
  docfiles = {
    Linux = callPackage ./docfiles/linux.nix { };
    Darwin = callPackage ./docfiles/darwin.nix { };
    Windows = callPackage ./docfiles/windows.nix { };
  };

  docfile =
    let
      uname-system = stdenv.hostPlatform.uname.system;
    in
    docfiles.${uname-system}.src or (throw "PySDL3 does not support ${uname-system}");
in
buildPythonPackage {
  pname = "pysdl3";
  inherit version;
  pyproject = true;

  pythonImportsCheck = [ "sdl3" ];

  src = fetchFromGitHub {
    owner = "Aermoss";
    repo = "PySDL3";
    tag = "v${version}";
    hash = "sha256-lUnQ5YDM6HXarZUSy+x95lStBXDQlvG5JL6hFdHg6z0=";
  };

  passthru = { inherit docfile; };

  postUnpack = ''
    cp ${docfile} source/sdl3/__doc__.py
  '';

  postInstall =
    let
      lib_ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir $out/${python.sitePackages}/sdl3/bin
      ln -s ${sdl3}/lib/libSDL3${lib_ext} -t $out/${python.sitePackages}/sdl3/bin
      ln -s ${sdl3-ttf}/lib/libSDL3_ttf${lib_ext} -t $out/${python.sitePackages}/sdl3/bin
      ln -s ${sdl3-image}/lib/libSDL3_image${lib_ext} -t $out/${python.sitePackages}/sdl3/bin
    '';

  build-system = [
    setuptools-scm
  ];

  buildInputs = [
    sdl3
    sdl3-ttf
    sdl3-image
  ];

  dependencies = [
    packaging
    aiohttp
    requests
  ];

  # PySDL3 tries to update both itself and SDL binaries at runtime. This hook
  # sets some env variables to tell it not to do that.
  setupHook = ./setup-hook.sh;

  env = {
    SDL_VIDEODRIVER = "dummy";
    SDL_AUDIODRIVER = "dummy";
    SDL_RENDER_DRIVER = "software";
    PYTHONFAULTHANDLER = "1";

    # For import checks, duplicated from setup hook.
    SDL_CHECK_BINARY_VERSION = 0;
    SDL_DISABLE_METADATA = 1;
    # Checks for __doc__.py next to the file being executed.
    # It's very fragile, and doesn't work during the import check.
    SDL_DOC_GENERATOR = 0;
  };

  meta = {
    description = "Pure Python wrapper for SDL3";
    homepage = "https://github.com/Aermoss/PySDL3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jansol
      alfarel
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-windows"
      "x86_64-windows"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
}
