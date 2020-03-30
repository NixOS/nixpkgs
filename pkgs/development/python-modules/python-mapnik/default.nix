{ stdenv
, buildPythonPackage
, isPyPy
, python
, pkgs
, pillow
, pycairo
}:

let
  boost = pkgs.boost.override {
    enablePython = true;
    inherit python;
  };
  mapnik = pkgs.mapnik.override {
    inherit python boost;
  };

in buildPythonPackage rec {
  pname = "python-mapnik";
  version = "unstable-2020-02-24";

  src = pkgs.fetchFromGitHub {
    owner = "mapnik";
    repo = "python-mapnik";
    rev = "7da019cf9eb12af8f8aa88b7d75789dfcd1e901b";
    sha256 = "0snn7q7w1ab90311q8wgd1z64kw1svm5w831q0xd6glqhah86qc8";
  };

  disabled = isPyPy;
  doCheck = false; # doesn't find needed test data files
  preBuild = let
    pythonVersion = with stdenv.lib.versions; "${major python.version}${minor python.version}";
  in ''
    export BOOST_PYTHON_LIB="boost_python${pythonVersion}"
    export BOOST_THREAD_LIB="boost_thread"
    export BOOST_SYSTEM_LIB="boost_system"
  '';

  nativeBuildInputs = [
    mapnik # for mapnik_config
  ];

  buildInputs = [
    mapnik
    boost
  ] ++ (with pkgs; [
    cairo
    harfbuzz
    icu
    libjpeg
    libpng
    libtiff
    libwebp
    proj
    zlib
  ]);
  propagatedBuildInputs = [ pillow pycairo ];

  meta = with stdenv.lib; {
    description = "Python bindings for Mapnik";
    homepage = https://mapnik.org;
    license  = licenses.lgpl21;
  };

}
