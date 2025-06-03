{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  scikit-build-core,
  pybind11,
  cmake,
  laszip,
  ninja,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "laszip-python";
  version = "0.2.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tmontaigu";
    repo = "laszip-python";
    rev = version;
    hash = "sha256-MiPzL9TDCf1xnCv7apwdfcpkFnBRi4PO/atTQxqL8cw=";
  };

  patches = [
    # Removes depending on the cmake and ninja PyPI packages, since we can pass
    # in the tools directly, and scikit-build-core can use them.
    # https://github.com/tmontaigu/laszip-python/pull/9
    (fetchpatch {
      name = "remove-cmake-ninja-pypi-dependencies.patch";
      url = "https://github.com/tmontaigu/laszip-python/commit/17e648d04945fa2d095d6d74d58c790a4fcde84a.patch";
      hash = "sha256-k58sS1RqVzT1WPh2OVt/D4Y045ODtj6U3bUjegd44VY=";
    })
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=c++17";

  nativeBuildInputs = [
    cmake
    ninja
    pybind11
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;

  buildInputs = [ laszip ];

  # There are no tests
  doCheck = false;

  pythonImportsCheck = [ "laszip" ];

  meta = with lib; {
    description = "Unofficial bindings between Python and LASzip made using pybind11";
    homepage = "https://github.com/tmontaigu/laszip-python";
    changelog = "https://github.com/tmontaigu/laszip-python/blob/${src.rev}/Changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
