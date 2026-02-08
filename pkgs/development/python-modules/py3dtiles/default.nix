{
  lib,
  fetchpatch2,
  fetchFromGitLab,
  addBinToPathHook,

  buildPythonPackage,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  lz4,
  mapbox-earcut,
  numba,
  numpy,
  psutil,
  pygltflib,
  pyproj,
  pyzmq,

  # optional-dependencies
  ifcopenshell,
  lark,
  laspy,
  plyfile,
  psycopg2-binary,

  # tests
  pytest-benchmark,
  pytest-cov-stub,
  pytestCheckHook,
  writeText,
  moreutils,
}:

buildPythonPackage (finalAttrs: {
  pname = "py3dtiles";
  version = "12.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "py3dtiles";
    repo = "py3dtiles";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m8c+g9XXbg9OSC+NNoQkw4RKXvNFRIPWkDjAs6oH3kc=";
  };

  patches = [
    # Remove in the next version
    # Patch to avoid using pythonRelaxDeps
    (fetchpatch2 {
      url = "https://gitlab.com/py3dtiles/py3dtiles/-/commit/0f60691434b9ad4afebec29b2eedfcbbe0b8420d.patch";
      includes = [ "pyproject.toml" ];
      hash = "sha256-TLoKeltI1xxSONX0uu56HKl2fXzAp1ufunsBPRr5Pus=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    lz4
    mapbox-earcut
    numba
    numpy
    psutil
    pygltflib
    pyproj
    pyzmq
  ];

  optional-dependencies = {
    ifc = [
      ifcopenshell
      lark
    ];
    las = [
      laspy
    ];
    ply = [
      plyfile
    ];
    postgres = [
      psycopg2-binary
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-benchmark
    pytest-cov-stub
    moreutils # chronic
  ];

  checkInputs = with finalAttrs.passthru.optional-dependencies; ply ++ las ++ ifc;

  nativeInstallCheckInputs = [
    addBinToPathHook
  ];

  # from .gitlab-ci.yml
  # note: nativeCheckInputs are also available for installCheckPhase
  # chronic - runs a command quietly unless it fails
  installCheckPhase =
    let
      testScript = writeText "test.py" /* py */ ''
        from py3dtiles.tileset.utils import number_of_points_in_tileset
        from pathlib import Path
        exit(number_of_points_in_tileset(Path("3dtiles/tileset.json")) != 22300)
      '';
    in
    ''
      runHook preInstallCheck
      chronic py3dtiles info tests/fixtures/pointCloudRGB.pnts
      chronic py3dtiles convert --out test1 ./tests/fixtures/simple.xyz
      chronic py3dtiles convert --out test2 ./tests/fixtures/with_srs_3857.las
      chronic py3dtiles convert tests/fixtures/simple.ply
      chronic python ${testScript}
      runHook pytestCheckPhase
      runHook postInstallCheck
    '';

  # disable benchmarks to reduce load on the builder
  pytestFlags = [ "--benchmark-disable" ];

  pythonImportsCheck = [
    "py3dtiles"
  ];

  meta = {
    changelog = "https://py3dtiles.org/main/changelog.html";
    description = "Python module to manage 3DTiles format";
    downloadPage = "https://gitlab.com/py3dtiles/py3dtiles";
    homepage = "https://py3dtiles.org";
    license = lib.licenses.asl20;
    mainProgram = "py3dtiles";
    teams = with lib.teams; [
      geospatial
      ngi
    ];
  };
})
