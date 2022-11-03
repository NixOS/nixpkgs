{ lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pythonOlder
}:

buildPythonPackage rec {
  pname = "clvm-tools-rs";
  version = "0.1.24";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "clvm_tools_rs";
    rev = version;
    sha256 = "sha256-1pXbmurR94JUPEUMCw0oFc4D8zL+TMbDLilbHEVqpzU=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-q7v4NY4EcKJ/LHoKM9BsitLnTfBpGc5p53FQ3CCL8Ls=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  pythonImportsCheck = [ "clvm_tools_rs" ];

  meta = with lib; {
    homepage = "https://chialisp.com/";
    description = "Rust port of clvm_tools";
    license = licenses.asl20;
    maintainers = teams.chia.members;
  };
}
