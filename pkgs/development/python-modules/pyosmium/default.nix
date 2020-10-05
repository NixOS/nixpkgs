{ lib, buildPythonPackage, fetchFromGitHub, cmake, python
, libosmium, protozero, boost, expat, bzip2, zlib, pybind11
, nose, shapely, mock, isPy3k }:

buildPythonPackage rec {
  pname = "pyosmium";
  version = "2.15.4";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vnamij2ysijb5s6gsgrwcakdpzc12h1kq1b4iwagrk6yynq64y7";
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
