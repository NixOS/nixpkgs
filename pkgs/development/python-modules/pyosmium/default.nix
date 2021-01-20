{ lib, buildPythonPackage, fetchFromGitHub, cmake, python
, libosmium, protozero, boost, expat, bzip2, zlib, pybind11
, nose, shapely, pythonOlder, isPyPy }:

buildPythonPackage rec {
  pname = "pyosmium";
  version = "3.1.0";

  disabled = pythonOlder "3.4" || isPyPy;

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m11hdgiysdhyi5yn6nj8a8ycjzx5hpjy7n1c4j6q5caifj7rf7h";
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
