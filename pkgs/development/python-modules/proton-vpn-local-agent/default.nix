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
  version = "1.6.1";
  pyproject = false;
  withDistOutput = false;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "local-agent-rs";
    rev = version;
    hash = "sha256-QELvjPJhS8nsQqNucwhMjbwDVg2YiESuhSB1XCN0o90=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-28WEWWI29EYADq/z7C01LxaeBJw8oWiF24iLpduJZ5w=";
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
    homepage = "https://github.com/ProtonVPN/local-agent-rs";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      anthonyroussel
      sebtm
      rapiteanu
    ];
  };
}
