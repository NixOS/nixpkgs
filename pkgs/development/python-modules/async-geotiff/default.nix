{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pytestCheckHook,
  uv-build,

  affine,
  async-tiff,
  defusedxml,
  numpy,
  pyproj,

  # tests
  pydantic,
  rasterio,
  morecantile,
  jsonschema,
  pytest-asyncio,
}:
buildPythonPackage (finalAttrs: {
  pname = "async-geotiff";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "async-geotiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J72/VRDAgqGOm7rYmlkURKgWSIa11L260LX447MQWbc=";
    fetchSubmodules = true;
  };

  patches = [
    # see https://github.com/developmentseed/async-geotiff/pull/136
    ./uv-build-relax-deps.patch
    # see https://github.com/developmentseed/async-tiff/pull/292
    (fetchpatch2 {
      url = "https://github.com/developmentseed/async-geotiff/commit/f8325c0decb2a7e61faf3db5e51ec5a104d3cbdb.patch?full_index=1";
      hash = "sha256-RLqMWKtjDSmxQkUXz9dXKIIqRXM7BWkuJIbbeHxCPyQ=";
    })
  ];

  build-system = [ uv-build ];

  # see https://github.com/developmentseed/async-geotiff/pull/133
  pythonRemoveDeps = [ "types-defusedxml" ];

  dependencies = [
    affine
    async-tiff
    defusedxml
    numpy
    pyproj
  ];

  pythonImportsCheck = [ "async_geotiff" ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    jsonschema
    morecantile
    rasterio
    pydantic
    pytest-asyncio
  ];

  meta = {
    description = "Fast, async GeoTIFF and COG reader for Python";
    homepage = "https://developmentseed.org/async-geotiff/latest/";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
  };
})
