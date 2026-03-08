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
  version = "4.2.0";
  pyproject = true;

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "pyosmium";
    tag = "v${version}";
    hash = "sha256-AkldgvZmn1CLa9Ze7RHBhL5wLLJ+mBnNj+yyV98nzZ8=";
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
    changelog = "https://github.com/osmcode/pyosmium/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
