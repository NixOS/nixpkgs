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
        ""
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

  # Install the `nixl` shim module (re-exports nixl_cu{12,13}).
  # Upstream builds this as a separate wheel via `uv build` (nixl-meta), but that doesn't work in
  # the sandbox.
  postInstall = ''
    install -Dm644 \
      src/bindings/python/nixl-meta/nixl/__init__.py \
      "$out/${python.sitePackages}/nixl/__init__.py"
  '';

  pythonImportsCheck = [
    "nixl"
  ]
  ++ lib.optionals cudaSupport [
    "nixl_cu${cudaPackages.cudaMajorVersion}"
  ];

  # No tests we can run in the sandbox
  doCheck = false;

  meta = nixl.meta // {
    description = "Python API for nixl";
  };
})
