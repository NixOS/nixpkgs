{ lib, buildPythonPackage, fetchFromGitHub, cmake, python
, libosmium, protozero, boost, expat, bzip2, zlib, pybind11
, nose, shapely, pythonOlder, isPyPy, lz4 }:

buildPythonPackage rec {
  pname = "pyosmium";
  version = "3.1.3";

  disabled = pythonOlder "3.4" || isPyPy;

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = pname;
    rev = "v${version}";
    sha256 = "11ma8nr7k2ixwwb55fiqvrj5qbmpgkyfk0canz4l0m8b7rcw3qsc";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libosmium protozero boost expat bzip2 zlib pybind11 lz4 ];

  preBuild = "cd ..";

  checkInputs = [ nose shapely ];

  checkPhase = "(cd test && ${python.interpreter} run_tests.py)";

  meta = with lib; {
    description = "Python bindings for libosmium";
    homepage = "https://osmcode.org/pyosmium";
    changelog = "https://github.com/osmcode/pyosmium/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
  };
}
