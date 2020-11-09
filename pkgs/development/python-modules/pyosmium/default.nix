{ lib, buildPythonPackage, fetchFromGitHub, cmake, python
, libosmium, protozero, boost, expat, bzip2, zlib, pybind11
, nose, shapely, pythonOlder, isPyPy }:

buildPythonPackage rec {
  pname = "pyosmium";
  version = "3.0.1";

  disabled = pythonOlder "3.4" || isPyPy;

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = pname;
    rev = "v${version}";
    sha256 = "06jngbmmmswhyi5q5bjph6gwss28d2azn5414zf0arik5bcvz128";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libosmium protozero boost expat bzip2 zlib pybind11 ];

  preBuild = "cd ..";

  checkInputs = [ nose shapely ];

  checkPhase = "(cd test && ${python.interpreter} run_tests.py)";

  meta = with lib; {
    description = "Python bindings for libosmium";
    homepage = "https://osmcode.org/pyosmium";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
  };
}
