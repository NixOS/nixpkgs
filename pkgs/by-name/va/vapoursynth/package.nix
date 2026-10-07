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
  version = "82";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ESgxZiCJC6jltpySSmZfmAAbK6QjDa3q0PKWRG6nGEM=";
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

  mesonFlags = [
    "-Db_lto=false" # fails with undefined symbols if on
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

    # Set fallback python interpreter
    export pythonExePath=${python3}
    export pythonSymbolPath=${python3}/lib/libpython3${stdenv.hostPlatform.extensions.sharedLibrary}
    substituteAllInPlace src/vsscript/vsscript.cpp
  '';

  postFixup = ''
    # Use the right interpreter inside a Nix environment (python3.withPackages)
    for prog in "$out"/bin/*; do
      sed -i "$prog" \
        -e '1a export VAPOURSYNTH_INTERP=$NIX_PYTHONEXECUTABLE' \
        -e "1a export PYTHONPATH=$out/${python3.sitePackages}"
    done

    # Link pkgconfig to a normal location
    ln -s "$out/${python3.sitePackages}/vapoursynth/pkgconfig" "$out/lib/"
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
