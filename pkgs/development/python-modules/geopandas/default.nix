{ stdenv, buildPythonPackage, fetchFromGitHub, isPy27
, pandas, shapely, fiona, descartes, pyproj
, pytest, Rtree, fetchpatch }:

buildPythonPackage rec {
  pname = "geopandas";
  version = "0.8.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "geopandas";
    repo = "geopandas";
    rev = "v${version}";
    sha256 = "0618p0s0biisxk2s0h43hkc3bs1nwjk84rxbfyd6brfvs9yx4vq7";
  };

  patches = [
    # Fix for test test_numerical_operations: https://github.com/geopandas/geopandas/issues/1541
    (fetchpatch {
      url = "https://github.com/geopandas/geopandas/pull/1544/commits/6ce868a33a2f483b071089d51e178030fa4414d0.patch";
      sha256 = "1sjgxrqgbhz5krx51hrv230ywszcdl6z8q3bj6830kfad8n8b5dq";
    })
  ];

  checkInputs = [ pytest Rtree ];

  checkPhase = ''
    py.test geopandas -m "not web"
  '';

  propagatedBuildInputs = [
    pandas
    shapely
    fiona
    descartes
    pyproj
  ];

  meta = with stdenv.lib; {
    description = "Python geospatial data analysis framework";
    homepage = "https://geopandas.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
