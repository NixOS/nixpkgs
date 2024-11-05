{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  libosmium,
  protozero,
  boost,
  expat,
  bzip2,
  zlib,
  pybind11,
  pythonOlder,
  pytest-httpserver,
  pytestCheckHook,
  setuptools,
  shapely,
  werkzeug,
  isPyPy,
  lz4,
  requests,
}:

buildPythonPackage rec {
  pname = "pyosmium";
  version = "4.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7" || isPyPy;

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "pyosmium";
    rev = "refs/tags/v${version}";
    hash = "sha256-qi4GsjQVe2nIcvQThAlxQu3kUdWhRuJFHVPjKbMBxdM=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ cmake ];

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

  dependencies = [ requests ];

  preBuild = "cd ..";

  nativeCheckInputs = [
    pytestCheckHook
    shapely
    werkzeug
    pytest-httpserver
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python bindings for libosmium";
    homepage = "https://osmcode.org/pyosmium";
    changelog = "https://github.com/osmcode/pyosmium/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
