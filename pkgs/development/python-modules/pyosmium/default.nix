{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, cmake
, libosmium
, protozero
, boost
, expat
, bzip2
, zlib
, pybind11
, shapely
, pythonOlder
, isPyPy
, lz4
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyosmium";
  version = "3.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6" || isPyPy;

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-+YJQGPQm2FGOPhNzlXX2GM+ad4QdipJhwViOKGHtqBk=";
  };

  patches = [
    # Compatibility with recent pybind versions
    (fetchpatch {
      url = "https://github.com/osmcode/pyosmium/commit/31b1363389b423f49e14140ce868ecac83e92f69.patch";
      hash = "sha256-maBuwzyZ4/wVLLGVr4gZFZDKvJckUXiBluxZRPGETag=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libosmium
    protozero
    boost
    expat
    bzip2
    zlib
    pybind11
    lz4
  ];

  propagatedBuildInputs = [
    requests
  ];

  preBuild = "cd ..";

  nativeCheckInputs = [
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
