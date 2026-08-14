{
  lib,
  buildPythonPackage,
  fetchPypi,
  scikit-build-core,
  pybind11,
  pybind11-stubgen,
  ruff,
  typing-extensions,
  numpy,
  cmake,
  ninja,
  psutil,
  docstring-parser,
  packaging,
  zeromq,
  cppzmq,
  omniorb,
  tango-cpp,
  opentelemetry-cpp,
  opentelemetry-api,
  opentelemetry-sdk,
  opentelemetry-exporter-otlp-proto-grpc,
  opentelemetry-exporter-otlp-proto-http,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytango";
  version = "10.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uFEJFeT4WbK5d1sjZBqy4tVpM8niDYnxMj7g1Vw88Ec=";
  };

  dontUseCmakeConfigure = true;

  postPatch = ''
    patchShebangs cmake/gen_stubs.sh
  '';

  build-system = [
    scikit-build-core
    pybind11
    numpy
    pybind11-stubgen
    ruff
    typing-extensions
  ];

  # nixpkgs currently has tango-cpp at 10.3.0. PyTango's own compatibility
  # rule is that libtango/cppTango and pytango should share the same
  # major.minor (10.3 here) - patch version doesn't need to match, so
  # 10.3.0 cppTango + 10.3.1 pytango is fine. Re-check this if either side
  # gets bumped later.
  buildInputs = [
    zeromq
    cppzmq
    omniorb
    tango-cpp
    opentelemetry-cpp
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  dependencies = [
    typing-extensions
    numpy
    psutil
    docstring-parser
    packaging
  ];

  passthru.optional-dependencies = {
    telemetry = [
      opentelemetry-api
      opentelemetry-sdk
      opentelemetry-exporter-otlp-proto-grpc
      opentelemetry-exporter-otlp-proto-http
    ];
  };

  doCheck = false;

  pythonImportsCheck = [ "tango" ];

  meta = {
    description = "Python bindings for the cppTango library, part of the Tango Distributed Control System toolkit";
    homepage = "https://www.tango-controls.org/";
    changelog = "https://gitlab.com/tango-controls/pytango/-/releases";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tincotema ];
  };
})
