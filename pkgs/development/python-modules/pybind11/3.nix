{
  pybind11,
  fetchPypi,

  # build-system
  cmake,
  ninja,
  scikit-build-core,
}:
pybind11.overridePythonAttrs (old: rec {
  version = "3.0.0";
  src = fetchPypi {
    inherit (old) pname;
    inherit version;
    hash = "sha256-w/B7zjraUcPkt2ut+oXfEWiNEsRhEfnSQrxclBWveGI=";
  };
  build-system = [
    cmake
    ninja
    scikit-build-core
  ];
})
