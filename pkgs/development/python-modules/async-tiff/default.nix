{
  # utils
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "async-tiff";
    tag = "py-v${finalAttrs.version}";
    hash = "sha256-o77iYqzBCloE5xgn0Sa6SWbrCMgnNuZwQ2MZ0wgtNew=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/developmentseed/async-tiff/commit/c7db2fc693089f3326328cc59863f8a9a6dd1cb9.patch?full_index=1";
      hash = "sha256-FsOZk8KZ3guqIoECYRsBQMEq8TrAQn9Z01NqUJAQOu8=";
    })
  ];

  postPatch = ''
    cd python
  '';

  buildSystem = [ maturin ];

  buildInputs = [ llvmPackages.libclang ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    pname = finalAttrs.pname;
    version = finalAttrs.version;
    src = finalAttrs.src;
    hash = "sha256-AKa4SsBYBCabMlYJqTcbHv9Z7ouqtiIEK0el/i/fo6I=";

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
