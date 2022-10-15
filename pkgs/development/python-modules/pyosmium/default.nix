{ lib, buildPythonPackage, fetchFromGitHub, cmake, python
, libosmium, protozero, boost, expat, bzip2, zlib, pybind11
, shapely, pythonOlder, isPyPy, lz4, requests, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyosmium";
  version = "3.4.1";

  disabled = pythonOlder "3.4" || isPyPy;

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-PMQnQe699ZWRR2gevrSCTokyc9xr1TL9Ohuqn7NL8c8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libosmium protozero boost expat bzip2 zlib pybind11 lz4 ];
  propagatedBuildInputs = [ requests ];

  preBuild = "cd ..";

  checkInputs = [
    pytestCheckHook
    shapely
  ];

  meta = with lib; {
    description = "Python bindings for libosmium";
    homepage = "https://osmcode.org/pyosmium";
    changelog = "https://github.com/osmcode/pyosmium/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
  };
}
