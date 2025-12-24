{
  lib,
  stdenv,
  fetchurl,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  cmake,
  ninja,
  tomli,
  pybind11,
  fetchFromGitHub,
  gnumake,
  # Python dependencies
  scipy,
  networkx,
  rustworkx,
  autograd,
  appdirs,
  autoray,
  cachetools,
  requests,
  tomlkit,
  typing-extensions,
  packaging,
  diastatic-malt,
  numpy,
  nanobind,
  blas,
  openblasCompat,
  scipy-openblas32,
  pennylane-catalyst-bin,
}:

buildPythonPackage rec {
  pname = "pennylane-lightning";
  version = "0.43.0";
  format = "wheel";

  disabled = pythonOlder "3.13";

  src =
    fetchurl
      {
        x86_64-linux = {
          url = "https://files.pythonhosted.org/packages/46/0f/7161bdc28fcbfab1341d66bbc106fc30db3d21d1caa6747994e9314655b1/pennylane_lightning-0.43.0-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
          hash = "sha256-a5viL4KQ4nWLePqle4x4m7RyzOVjeolqEMnIh3KqGDw=";
        };
      }
      ."${stdenv.hostPlatform.system}"
        or (throw "Unsupported system for ${pname}: ${stdenv.hostPlatform.system}");

  dependencies = [
    scipy
    networkx
    rustworkx
    autograd
    appdirs
    autoray
    cachetools
    requests
    tomlkit
    typing-extensions
    packaging
    diastatic-malt
    numpy
    nanobind
    scipy-openblas32
  ];

  SCIPY_OPENBLAS32 = "${scipy-openblas32}/lib/python3.13/site-packages/scipy_openblas32/lib";

  propagatedBuildInputs = [
    openblasCompat
    scipy-openblas32
    pennylane-catalyst-bin
  ];

  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_NANOBIND=${nanobind.src}"
  ];

  doCheck = true;

  pythonImportsCheck = [ "pennylane_lightning" ];

  meta = {
    homepage = "https://github.com/PennyLaneAI/pennylane-lightning";
    description = "PennyLane plugins";
    maintainers = with lib.maintainers; [ anderscs ];
    license = lib.licenses.asl20;
  };
}
