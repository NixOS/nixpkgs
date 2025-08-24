{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cffi,
  libiconv,
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
  version = "0.6.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pyocd";
    repo = "cmsis-pack-manager";
    tag = "v${version}";
    hash = "sha256-kb0VSg89qglL6Q5kx1nEN1OW1GYoccBTITtPw2/dXTY=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-yRNSFlEwFhfkSNjbFHipVZvJZ40pKbI9HhLtciws7nc=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];
  propagatedNativeBuildInputs = [ cffi ];
  buildInputs = [
    libiconv
  ];
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
    description = "Rust and Python module for handling CMSIS Pack files";
    homepage = "https://github.com/pyocd/cmsis-pack-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [
      frogamic
      sbruder
    ];
  };
}
