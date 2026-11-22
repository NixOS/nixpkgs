{
  lib,
  buildPythonPackage,
  setuptools,
  basemap,
}:

buildPythonPackage (finalAttrs: {
  pname = "basemap-data";
  pyproject = true;
  inherit (basemap) version src;

  build-system = [ setuptools ];

  sourceRoot = "${finalAttrs.src.name}/data/basemap_data";

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "mpl_toolkits.basemap_data" ];

  meta = {
    homepage = "https://matplotlib.org/basemap/";
    description = "Data assets for matplotlib basemap";
    license = with lib.licenses; [
      mit
      lgpl3Plus
    ];
    teams = [ lib.teams.geospatial ];
  };
})
