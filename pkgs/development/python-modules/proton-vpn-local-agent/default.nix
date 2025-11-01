{
  lib,
  stdenv,
  fetchFromGitHub,
  python,
  buildPythonPackage,
  cargo,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "proton-vpn-local-agent";
  version = "1.4.8-unstable-2025-10-29";
  pyproject = false;
  withDistOutput = false;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-local-agent";
    rev = "0f7a7fa240f3d539896bbf7cdc3539f4daa3e1de";
    hash = "sha256-rk3wi6q0UDuwh5yhLBqdLYsJxVqhlI+Yc7HZsiAU1Y8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-jjSkPgGp3Yvypnlrt9pV1F/K3o2doNteQs1rwr5fhnM=";
  };

  sourceRoot = "${src.name}/python-proton-vpn-local-agent";

  cargoBuildType = "release";
  nativeBuildInputs = [
    cargo
    python.pkgs.pip
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
  ];

  cargoCheckType = "release";
  nativeCheckInputs = [
    rustPlatform.cargoCheckHook
  ];

  buildPhase = ''
    runHook preBuild
    cargoBuildHook
    ${python.interpreter} scripts/build_wheel.py
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ${python.interpreter} -m pip install --no-deps --prefix=$out ./target/*.whl
    runHook postInstall
  '';

  pythonImportsCheck = [ "proton.vpn.local_agent" ];

  meta = {
    description = "Proton VPN local agent written in Rust with Python bindings";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-local-agent";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
