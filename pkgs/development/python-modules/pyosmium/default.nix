{ lib, buildPythonPackage, fetchFromGitHub, cmake, python
, libosmium, protozero, boost, expat, bzip2, zlib, pybind11
, nose, shapely, mock, isPy3k }:

buildPythonPackage rec {
  pname = "pyosmium";
  version = "2.15.3";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = pname;
    rev = "v${version}";
    sha256 = "1523ym9i4rnwi5kcp7n2lm67kxlhar8xlv91s394ixzwax9bgg7w";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libosmium protozero boost expat bzip2 zlib pybind11 ];

  preBuild = "cd ..";

  checkInputs = [ nose shapely ] ++ lib.optionals (!isPy3k) [ mock ];

  checkPhase = "(cd test && ${python.interpreter} run_tests.py)";

  meta = with lib; {
    description = "Python bindings for libosmium";
    homepage = "https://osmcode.org/pyosmium";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
  };
}
