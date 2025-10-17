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
  version = "1.4.8";
  pyproject = false;
  withDistOutput = false;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-local-agent";
    rev = version;
    hash = "sha256-AHY2b0JaYaLhgnNkTsm9ERkw0s0NWnpbPAPgw+r2Gz4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-zzUZsF0R0QGhxe4To6xSHYUVJTIDddf+UdTJg7E9Ef8=";
  };

  sourceRoot = "${src.name}/python-proton-vpn-local-agent";

  cargoBuildType = "release";
  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.cargoBuildHook
  ];

  cargoCheckType = "release";
  nativeCheckInputs = [
    rustPlatform.cargoCheckHook
  ];

  installPhase = ''
    runHook preInstall

    # manually install the python binding
    mkdir -p $out/${python.sitePackages}/proton/vpn/
    cp ./target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/libpython_proton_vpn_local_agent.so $out/${python.sitePackages}/proton/vpn/local_agent.so

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
