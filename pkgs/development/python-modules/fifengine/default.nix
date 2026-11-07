{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  toPythonModule,
  python,
  pythonImportsCheckHook,
  cmake,
  swig,
  boost,
  fifechan,
  freealut,
  glew,
  libGL,
  libogg,
  libpng,
  libvorbis,
  libxcursor,
  openal,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  tinyxml,
  zlib,
}:

let
  # Debian maintains the only patch set for the 0.4.x line, pinned to the
  # commit behind the fife 0.4.3-1 upload.
  debianPatch =
    { name, hash }:
    fetchpatch2 {
      inherit name hash;
      url = "https://salsa.debian.org/games-team/fife/-/raw/913e09dd8ec30530fb08e1a3e12c885d228cb3fd/debian/patches/${name}";
    };
in
toPythonModule (
  stdenv.mkDerivation (finalAttrs: {
    pname = "fifengine";
    # Snapshot release preserving the 0.4.x line; master is being rewritten
    # towards 0.5.0 and is not a drop-in successor.
    version = "0.4.3";

    src = fetchFromGitHub {
      owner = "fifengine";
      repo = "fifengine";
      tag = finalAttrs.version;
      hash = "sha256-DQv4SZo3SqlkpY8K0w/AiJk9WXEeb2ubKGQHynX4M+k=";
    };

    patches = [
      # Drop the python-future dependency.
      (debianPatch {
        name = "remove_future.patch";
        hash = "sha256-XpvUxkFC2joaC3Or8Yq+nQjJWwXcQ4DpPYEDJjffIW0=";
      })
      # boost::filesystem::extension() was removed in Boost 1.85.
      (debianPatch {
        name = "Fix-build-against-boost-1.85.patch";
        hash = "sha256-BxqT8Kmy+syncMOxVkirquKv+RtKTTSLqOuWM4EShUE=";
      })
      # SWIG 4 stopped generating classes for C++ typedefs; re-add
      # fife.ModelCoordinate and friends, which consumers use.
      (debianPatch {
        name = "swig-typedef.patch";
        hash = "sha256-DbY3Z1oNkLIBj0riJsVE0rZF6uI5idpEGGoFAdD0epU=";
      })
      # Let external CXXFLAGS override the hardcoded -O2.
      (debianPatch {
        name = "buildflags_order.patch";
        hash = "sha256-EAa76VHZG7p5KHuYAphmSE3ZOcMfp0rcinNhXqt/EtU=";
      })
      # Boost.System was removed in 1.89.
      (debianPatch {
        name = "boost-1.89.patch";
        hash = "sha256-+ak0dxthhPzQjtqaxNhqZAqh4MuPbkSN30K7DGMOOK4=";
      })
      # Corrects the version, and lowers cmake_minimum_required so that
      # swig_add_library() keeps creating the `_fife` target the install
      # rules reference (pre-CMP0078 behaviour).
      (debianPatch {
        name = "cmake_fix.patch";
        hash = "sha256-ekz8evV36TulJ1MH55RtuQVVwqcIKl8jZ91O/V2Fw1s=";
      })
    ];

    nativeBuildInputs = [
      cmake
      swig
      python
      pythonImportsCheckHook
    ];

    buildInputs = [
      boost
      fifechan
      freealut
      glew
      libGL
      libogg
      libpng
      libvorbis
      libxcursor
      openal
      python
      SDL2
      SDL2_image
      SDL2_ttf
      tinyxml
      zlib
    ];

    cmakeFlags = [
      (lib.cmakeFeature "PYTHON_EXECUTABLE" "${python.interpreter}")
      (lib.cmakeFeature "PYTHON_SITE_PACKAGES" "${placeholder "out"}/${python.sitePackages}")
      (lib.cmakeFeature "OPENALSOFT_INCLUDE_DIR" "${openal}/include")
      "-Wno-dev"
    ];

    pythonImportsCheck = [ "fife.fife" ];

    meta = {
      description = "Multi-platform isometric game engine with Python bindings";
      homepage = "https://www.fifengine.net/";
      license = lib.licenses.lgpl21Plus;
      maintainers = with lib.maintainers; [ FlorianFranzen ];
      platforms = lib.platforms.linux;
    };
  })
)
