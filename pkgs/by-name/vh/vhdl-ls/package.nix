{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "vhdl-ls";
<<<<<<< HEAD
  version = "0.86.0";
=======
  version = "0.85.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "VHDL-LS";
    repo = "rust_hdl";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-H8s4YZPpe7Z3IafY4lt4Gn/jjeULJFSA/6kMb9IrV50=";
  };

  cargoHash = "sha256-ULJpmT8DXSr6hqBxn6weWJUmplCboxhSekxaWmu4aHE=";
=======
    hash = "sha256-uqJiPJ86zX9r44F8D6tabw7Cp24WQoQTen3VqnjlYu0=";
  };

  cargoHash = "sha256-ZC9HwMwrK3xWKr+gnf3SGMUcSRkvV3HL5h9R2lmfW9Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postPatch = ''
    substituteInPlace vhdl_lang/src/config.rs \
      --replace /usr/lib $out/lib
  '';

  postInstall = ''
    mkdir -p $out/lib/rust_hdl
    cp -r vhdl_libraries $out/lib/rust_hdl
  '';

  meta = {
    description = "Fast VHDL language server";
    homepage = "https://github.com/VHDL-LS/rust_hdl";
    license = lib.licenses.mpl20;
    mainProgram = "vhdl_ls";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
