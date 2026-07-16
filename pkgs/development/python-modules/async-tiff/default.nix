{
  # utils
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  rustPlatform,

  # build and dependencies
  llvmPackages,
  maturin,
  obspec,

  # tests dependencies
  pytestCheckHook,
  numpy,
  obstore,
  pytest-asyncio,
  rasterio,
}:
buildPythonPackage (finalAttrs: {
  pname = "async-tiff";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "async-tiff";
    tag = "py-v${finalAttrs.version}";
    hash = "sha256-F2pweyNQMvSZeOn6kNcfk3cPqvaP1d7yAT/ygJvWxjo=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cd python
  '';

  buildSystem = [ maturin ];

  buildInputs = [ llvmPackages.libclang ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    pname = finalAttrs.pname;
    version = finalAttrs.version;
    src = finalAttrs.src;
    hash = "sha256-7iT1ZIdwlztHFEGEseEQEHzY/vqjXX/X6s5Uc3WaKxc=";

    preBuild = ''
      cd python
    '';
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
    rustPlatform.bindgenHook
  ];

  dependencies = [
    obspec
  ];

  pythonImportsCheck = [ "async_tiff" ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    numpy
    obstore
    pytest-asyncio
    rasterio
  ];

  disabledTests = [
    # network access
    "test_cog_s3"
    "test_raise_typeerror_fetch_tile_striped_tiff"
  ];

  meta = {
    description = "Async TIFF reader for Python";
    homepage = "http://developmentseed.org/async-tiff/";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
  };
})
