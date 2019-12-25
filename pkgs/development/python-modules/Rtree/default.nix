{ stdenv, buildPythonPackage, fetchPypi, libspatialindex, numpy }:

buildPythonPackage rec {
  pname = "Rtree";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a34b25f588e1563e45af251a8469b43a125d972eb2fa66e9ce96ed29f06c454";
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
