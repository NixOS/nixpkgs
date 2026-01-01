{
  lib,
  buildPythonPackage,
  basemap,
}:

buildPythonPackage rec {
  pname = "basemap-data";
  format = "setuptools";
  inherit (basemap) version src;

  sourceRoot = "${src.name}/data/basemap_data";

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "mpl_toolkits.basemap_data" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://matplotlib.org/basemap/";
    description = "Data assets for matplotlib basemap";
    license = with lib.licenses; [
      mit
      lgpl3Plus
    ];
    teams = [ lib.teams.geospatial ];
=======
  meta = with lib; {
    homepage = "https://matplotlib.org/basemap/";
    description = "Data assets for matplotlib basemap";
    license = with licenses; [
      mit
      lgpl3Plus
    ];
    teams = [ teams.geospatial ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
