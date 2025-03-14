{
  lib,
  buildPythonPackage,
  setuptools,
  basemap,
}:

buildPythonPackage rec {
  pname = "basemap-data-hires";
  pyproject = true;
  inherit (basemap) version src;

  sourceRoot = "${src.name}/packages/basemap_data_hires";

  build-system = [
    setuptools
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "mpl_toolkits.basemap_data" ];

  meta = {
    homepage = "https://matplotlib.org/basemap/";
    description = "High-resolution data assets for matplotlib basemap";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
