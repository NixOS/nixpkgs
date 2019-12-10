{ stdenv, buildPythonPackage, fetchPypi, libspatialindex, numpy }:

buildPythonPackage rec {
  pname = "Rtree";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "140j1vsbcj6sivq1b6pgkwm0czivx2x3d66mqq0d9ymg46njrzn9";
  };

  propagatedBuildInputs = [ libspatialindex ];

  patchPhase = ''
    substituteInPlace rtree/core.py --replace \
      "find_library('spatialindex_c')" "'${libspatialindex}/lib/libspatialindex_c${stdenv.hostPlatform.extensions.sharedLibrary}'"
  '';

  # Tests appear to be broken due to mysterious memory unsafe issues. See #36760
  doCheck = false;
  checkInputs = [ numpy ];

  meta = with stdenv.lib; {
    description = "R-Tree spatial index for Python GIS";
    homepage = https://toblerity.org/rtree/;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ bgamari ];
  };
}
