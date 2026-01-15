{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pybind11,
  numpy,
}:
let
  pname = "lanms-neo";
  version = "1.0.2";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gen-ko";
    repo = "lanms-neo";
    rev = "6510e19e731a1e105d42b2fbda64de41c169ce2e";
    hash = "sha256-0fs4RNN1ptiir7GfR9B8HK0VqTkk5PbVJxgKiDId3po=";
  };

  propagatedBuildInputs = [
    pybind11
    numpy
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Standalone module for Locality-Aware NMS";
    homepage = "https://github.com/gen-ko/lanms-neo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
