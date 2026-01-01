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
<<<<<<< HEAD
  version = "0.6.0";
=======
  version = "0.5.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pyocd";
    repo = "cmsis-pack-manager";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-kb0VSg89qglL6Q5kx1nEN1OW1GYoccBTITtPw2/dXTY=";
=======
    hash = "sha256-PeyJf3TGUxv8/MKIQUgWrenrK4Hb+4cvtDA2h3r6kGg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
<<<<<<< HEAD
    hash = "sha256-yRNSFlEwFhfkSNjbFHipVZvJZ40pKbI9HhLtciws7nc=";
=======
    hash = "sha256-OBh5WWSekrqdLLmxEXS0LfPIfy4QWKYgO+8o6PYWjN4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Rust and Python module for handling CMSIS Pack files";
    homepage = "https://github.com/pyocd/cmsis-pack-manager";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Rust and Python module for handling CMSIS Pack files";
    homepage = "https://github.com/pyocd/cmsis-pack-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      frogamic
      sbruder
    ];
  };
}
