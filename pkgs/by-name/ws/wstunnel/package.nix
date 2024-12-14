{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  nixosTests,
  nix-update-script,
  versionCheckHook,
  apple-sdk_11,
}:

let
  version = "10.1.7";
in

rustPlatform.buildRustPackage {
  pname = "wstunnel";
  inherit version;

  src = fetchFromGitHub {
    owner = "erebe";
    repo = "wstunnel";
    rev = "v${version}";
    hash = "sha256-WqTHU4W/MUzmJ/totr8vfSDlNXirJE5KfgNglOen65w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Cs6zSHvqItqwGh3FMn7Iv7SyMk72sp6cH9Wn09UYMsk=";

  nativeBuildInputs = [ versionCheckHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_11
  ];

  doInstallCheck = true;

  checkFlags = [
    # Tries to launch a test container
    "--skip=tcp::tests::test_proxy_connection"
    "--skip=protocols::tcp::server::tests::test_proxy_connection"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      nixosTest = nixosTests.wstunnel;
    };
  };

  meta = {
    description = "Tunnel all your traffic over Websocket or HTTP2 - Bypass firewalls/DPI";
    homepage = "https://github.com/erebe/wstunnel";
    changelog = "https://github.com/erebe/wstunnel/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      raylas
      rvdp
      neverbehave
    ];
    mainProgram = "wstunnel";
  };
}
