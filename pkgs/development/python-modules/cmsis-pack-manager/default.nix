{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cffi,
  libiconv,
  stdenv,
  darwin,
  buildPythonPackage,
  appdirs,
  pyyaml,
  hypothesis,
  jinja2,
  pytestCheckHook,
  unzip,
}:

buildPythonPackage rec {
  pname = "cmsis-pack-manager";
  version = "0.5.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pyocd";
    repo = "cmsis-pack-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-PeyJf3TGUxv8/MKIQUgWrenrK4Hb+4cvtDA2h3r6kGg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-dO4qw5Jx0exwb4RuOhu6qvGxQZ+LayHtXDHZKADLTEI=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [ libiconv ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;
  propagatedBuildInputs = [
    appdirs
    pyyaml
  ];
  nativeCheckInputs = [
    hypothesis
    jinja2
    pytestCheckHook
    unzip
  ];

  # remove cmsis_pack_manager source directory so that binaries can be imported
  # from the installed wheel instead
  preCheck = ''
    rm -r cmsis_pack_manager
  '';

  disabledTests = [
    # All require DNS.
    "test_pull_pdscs"
    "test_install_pack"
    "test_pull_pdscs_cli"
    "test_dump_parts_cli"
  ];

  meta = with lib; {
    description = "A Rust and Python module for handling CMSIS Pack files";
    homepage = "https://github.com/pyocd/cmsis-pack-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [
      frogamic
      sbruder
    ];
  };
}
