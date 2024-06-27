{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  patchelf,
  rustPlatform,
  rustc,
  numpy,
}:

buildPythonPackage rec {
  pname = "fpsample";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "leonardodalinky";
    repo = "fpsample";
    rev = "v${version}";
    hash = "sha256-3Z5CZsnXjVFYkUBs1hTNuMCr60HUHSgLueq6Ew0EgiI=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-rwy+co9QiURje0yj7/dw5wrgt/KMWO6DKHqWKcUwbYU=";
  };

  nativeBuildInputs = [
    cargo
    patchelf
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "fpsample" ];

  meta = {
    description = "Python efficient farthest point sampling (FPS) library. Compatible with numpy";
    homepage = "https://github.com/leonardodalinky/fpsample";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
