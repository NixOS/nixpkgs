{ stdenv, buildPythonPackage, fetchPypi, libspatialindex, numpy }:

buildPythonPackage rec {
  pname = "Rtree";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55c046a98e8d84235792de1f18635f680d7b4085264fbced6b073f28fcbe353a";
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
