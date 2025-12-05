{
  lib,
  stdenv,
  fetchFromGitHub,
  python,
  buildPythonPackage,
  cargo,
  pypaInstallHook,
  rustPlatform,
}:

buildPythonPackage rec {
  pname = "proton-vpn-local-agent";
  version = "1.6.0";
  pyproject = false;
  withDistOutput = false;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-local-agent";
    rev = version;
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
    pypaInstallHook
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
  ];

  cargoCheckType = "release";
  nativeCheckInputs = [
    rustPlatform.cargoCheckHook
  ];

  postPatch = ''
    substituteInPlace scripts/build_wheel.py \
      --replace-fail 'ARCH = "x86_64"' \
                     'ARCH = "${stdenv.hostPlatform.uname.processor}"' \
      --replace-fail 'LIB_PATH = get_lib_path("x86_64-unknown-linux-gnu")' \
                     'LIB_PATH = get_lib_path("${stdenv.hostPlatform.config}")'
  '';

  postBuild = ''
    ${python.interpreter} scripts/build_wheel.py
    mkdir -p ./dist
    cp ./target/*.whl ./dist
  '';

  pythonImportsCheck = [ "proton.vpn.local_agent" ];

  meta = {
    description = "Proton VPN local agent written in Rust with Python bindings";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-local-agent";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sebtm
      rapiteanu
    ];
  };
}
