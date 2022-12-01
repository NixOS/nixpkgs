{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, numpy
, pybind11
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "mapbox-earcut";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "skogler";
    repo = "mapbox_earcut_python";
    rev = "v${version}";
    sha256 = "m4q2qTL55fkdi3hm75C3/XV9SUQkpJS+B5SEgpPEctk=";
  };

  nativeBuildInputs = [ setuptools pybind11 ];

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mapbox_earcut" ];

  meta = with lib; {
    homepage = "https://github.com/skogler/mapbox_earcut_python";
    license = licenses.isc;
    description = "Mapbox-earcut fast triangulation of 2D-polygons";
    longDescription = ''
      Python bindings for the C++ implementation of the Mapbox Earcut
      library, which provides very fast and quite robust triangulation of 2D
      polygons.
    '';
    maintainers = with maintainers; [ friedelino ];
  };
}
