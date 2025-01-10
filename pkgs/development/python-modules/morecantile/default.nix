{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  attrs,
  click,
  flit,
  mercantile,
  pydantic,
  pyproj,
  rasterio,
}:

buildPythonPackage rec {
  pname = "morecantile";
  version = "6.1.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "developmentseed";
    repo = "morecantile";
    tag = version;
    hash = "sha256-+gfmXbse3fnLepZQBwuC8KTNmJs7Lb69jvV89Bv9DF8=";
  };

  nativeBuildInputs = [ flit ];

  propagatedBuildInputs = [
    attrs
    click
    pydantic
    pyproj
  ];

  nativeCheckInputs = [
    mercantile
    pytestCheckHook
    rasterio
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/developmentseed/morecantile/issues/156
    "test_tiles_when_tms_bounds_and_provided_bounds_cross_antimeridian"
  ];

  pythonImportsCheck = [ "morecantile" ];

  meta = {
    description = "Construct and use map tile grids in different projection";
    homepage = "https://developmentseed.org/morecantile/";
    license = lib.licenses.mit;
    maintainers = lib.teams.geospatial.members;
    mainProgram = "morecantile";
  };
}
