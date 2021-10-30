{ lib
, buildPythonPackage
, fetchFromGitHub
, isPyPy
, python
, pillow
, pycairo
, pkg-config
, boost
, cairo
, harfbuzz
, icu
, libjpeg
, libpng
, libtiff
, libwebp
, mapnik
, proj
, zlib
}:

buildPythonPackage rec {
  pname = "python-mapnik";
  version = "unstable-2020-02-24";

  src = fetchFromGitHub {
    owner = "mapnik";
    repo = "python-mapnik";
    rev = "7da019cf9eb12af8f8aa88b7d75789dfcd1e901b";
    sha256 = "0snn7q7w1ab90311q8wgd1z64kw1svm5w831q0xd6glqhah86qc8";
  };

  disabled = isPyPy;
  doCheck = false; # doesn't find needed test data files
  preBuild = ''
    export BOOST_PYTHON_LIB="boost_python${"${lib.versions.major python.version}${lib.versions.minor python.version}"}"
    export BOOST_THREAD_LIB="boost_thread"
    export BOOST_SYSTEM_LIB="boost_system"
    export PYCAIRO=true
  '';

  nativeBuildInputs = [
    mapnik # for mapnik_config
    pkg-config
  ];

  patches = [
    ./find-pycairo-with-pkg-config.patch
  ];

  buildInputs = [
    mapnik
    boost
    cairo
    harfbuzz
    icu
    libjpeg
    libpng
    libtiff
    libwebp
    proj
    zlib
  ];

  propagatedBuildInputs = [ pillow pycairo ];

  pythonImportsCheck = [ "mapnik" ];

  meta = with lib; {
    description = "Python bindings for Mapnik";
    maintainers = with maintainers; [ ];
    homepage = "https://mapnik.org";
    license = licenses.lgpl21;
  };
}
