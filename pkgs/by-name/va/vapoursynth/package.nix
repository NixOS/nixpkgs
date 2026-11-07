{
  lib,
  stdenv,
  python3Packages,
  fetchPypi,
  pkg-config,
  ninja,
  zimg,
  libass,
  glslang,
  vulkan-headers,
  vapoursynth,
  python3,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "vapoursynth";
  version = "80";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-TQPj72TfZahVSQ5v13zMdNXev4l5muqTpr0I9qkK/rA=";
  };

  build-system = [
    python3Packages.meson-python
  ];

  nativeBuildInputs = [
    pkg-config
    ninja
    python3Packages.sphinx
    python3Packages.cython
  ];

  buildInputs = [
    zimg
    libass
    vulkan-headers
    glslang
  ];

  # Link system glslang
  env.NIX_LDFLAGS = "-L${glslang.out}/lib -lglslang -lglslang-default-resource-limits";

  makeWrapperArgs = [
    "--set"
    "PYTHONPATH"
    "$out/${python3.sitePackages}"
  ];

  patches = [
    ./ignore-vapoursynth-toml.patch
  ];

  postPatch = ''
    # Disable vendored glslang (it tries to download from the internet)
    substituteInPlace meson.build --replace-fail \
      "glslang_dep = subproject('glslang').get_variable('glslang_dep')" \
      "glslang_dep = dependency('zimg', version: '>=1.4')"

    # Relax cython version check
    substituteInPlace pyproject.toml --replace-fail 'Cython>=3.3.0' Cython

    # Fix python interpreter
    export pythonExePath=${python3.interpreter}
    export pythonSymbolPath=${python3}/lib/libpython3${stdenv.hostPlatform.extensions.sharedLibrary}
    substituteAllInPlace src/vsscript/vsscript.cpp
  '';

  meta = {
    description = "Video processing framework with the future in mind";
    homepage = "http://www.vapoursynth.com/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      rnhmjoj
      snaki
    ];
    mainProgram = "vspipe";
  };
})
