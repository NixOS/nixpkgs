{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pybind11
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mapbox-earcut";
  version = "unstable-2021-02-16";

  src = fetchFromGitHub {
    owner = "skogler";
    repo = "mapbox_earcut_python";
    rev = "257c2c82819acf72b2b757f200c160e55b9427fc";
    sha256 = "14z2vj13a1qcaqc6jvg00f367la5470bclvfi9mmlvpac3hhhywd";
  };

  postPatch =''
    substituteInPlace tests/test_earcut.py --replace \
    "pytest.raises(ValueError, message=\"Expecting ValueError\")" \
    "pytest.raises(ValueError)"
  '';

  buildInputs = [ pybind11 ];

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytestCheckHook ];

  doCheck = true;

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
