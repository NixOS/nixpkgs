{
  lib,
  buildPythonPackage,
  nanoarrow-c,

  # build-system
  cython,
  meson,
  meson-python,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  zlib,
  zstd-c,

  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  inherit (nanoarrow-c)
    pname
    version
    src
    postPatch
    ;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/python";

  build-system = [
    cython
    meson
    meson-python
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zlib
    zstd-c
  ];

  mesonFlags = [
    # Use system zstd instead of the meson wrap
    (lib.mesonOption "force_fallback_for" "flatcc")
  ];

  pythonImportsCheck = [ "nanoarrow" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = nanoarrow-c.meta // {
    description = "Python bindings to the nanoarrow C library";
    homepage = "https://github.com/apache/arrow-nanoarrow/tree/main/python";
    maintainers = with lib.maintainers; [
      GaetanLepage
      doronbehar
    ];
  };
})
