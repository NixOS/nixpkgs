{ stdenv
, buildPythonPackage
, fetchFromGitHub
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
  version = "3.0.16";

  src = pkgs.fetchFromGitHub {
    owner = "mapnik";
    repo = "python-mapnik";
    rev = "v${version}";
    sha256 = "1gqs4kvmjawdgl80j0ab5r8y0va9kw0rvwix3093xsv4hwd00lcc";
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
