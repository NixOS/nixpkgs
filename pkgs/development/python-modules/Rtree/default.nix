{ stdenv, buildPythonPackage, fetchPypi, libspatialindex, numpy }:

buildPythonPackage rec {
  pname = "Rtree";
  version = "0.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jc62jbcqqpjcwcly7l9zk25bg72mrxmjykpvfiscgln00qczfbc";
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
