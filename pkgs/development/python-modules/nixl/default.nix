{
  lib,
  buildPythonPackage,
  python,
  nixl,

  # build-system
  build,
  meson-python,
  pybind11,
  pytest,
  pyyaml,
  setuptools,
  types-pyyaml,

  # dependencies
  numpy,
  torch,

  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}:

buildPythonPackage.override { inherit (nixl) stdenv; } (finalAttrs: {
  inherit (nixl)
    pname
    version
    src
    __structuredAttrs
    strictDeps
    nativeBuildInputs
    dontUseCmakeConfigure
    buildInputs
    mesonFlags
    ;
  pyproject = true;

  postPatch = (nixl.postPatch or "") + ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        '"patchelf",' \
        "" \
      --replace-fail \
        "torch==2.11.*" \
        "torch"
  '';

  build-system = [
    build
    meson-python
    pybind11
    pytest
    pyyaml
    setuptools
    torch
    types-pyyaml
  ];
  dontUseMesonConfigure = true;

  dependencies = [
    numpy
    torch
  ];

  # Install the `nixl` shim module (re-exports nixl_cu{12,13}) along with its `nixl_meta_utils`
  # helper.
  # Upstream builds these as a separate wheel via `uv build` (nixl-meta), but that doesn't work in
  # the sandbox.
  postInstall = ''
    install -Dm644 \
      src/bindings/python/nixl-meta/nixl/__init__.py \
      "$out/${python.sitePackages}/nixl/__init__.py"

    install -Dm644 \
      src/bindings/python/nixl-meta/nixl_meta_utils.py \
      "$out/${python.sitePackages}/nixl_meta_utils.py"
  '';

  pythonImportsCheck = [
    "nixl"
  ]
  ++ lib.optionals cudaSupport [
    "nixl_cu${cudaPackages.cudaMajorVersion}"
  ];

  # No tests we can run in the sandbox
  doCheck = false;

  # The wheel installs as `nixl_cu{12,13}`, while the plain `nixl` module is a metadata-less shim
  # (see postInstall), so there is no `nixl` .dist-info to check.
  dontCheckPythonMetadata = true;

  meta = nixl.meta // {
    description = "Python API for nixl";
  };
})
