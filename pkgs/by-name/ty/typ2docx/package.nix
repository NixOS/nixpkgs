{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,

  pkg-config,
  openssl,

  pandoc,
}:
python3Packages.buildPythonApplication rec {
  pname = "typ2docx";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sghng";
    repo = "typ2docx";
    tag = "v${version}";
    hash = "sha256-8Jb13qiS+dpyfJS4m2T6STzORs1VzRKwC8GGgEwiVtU=";
  };

  lockFile = fetchurl {
    url = "https://github.com/sghng/typ2docx/releases/download/v${version}/Cargo.lock";
    hash = "sha256-irWv7+uqNyyq42JVLSy9WQz78ynYVsYuQ8fk5nardWw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      postPatch
      ;
    hash = "sha256-Gvdj9izGCem0A3Cy7RBzNzJ57lxk5GRP8I2C2T6RsbY=";
  };

  postPatch = ''
    ln -s ${lockFile} Cargo.lock
  '';

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    pkg-config
  ];

  build-system = with python3Packages; [
    uv-build
  ];

  dependencies = with python3Packages; [
    pdf2docx
    pdfservices-sdk
    pypdf
    rich
    saxonche
    typer
  ];

  buildInputs = [
    openssl
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${lib.makeBinPath [ pandoc ]}"
    "--prefix"
    "PYTHONPATH"
    ":"
    "$PYTHONPATH"
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Convert Math-Rich Typst Project to Microsoft Word Format";
    homepage = "https://github.com/sghng/typ2docx";
    changelog = "https://github.com/sghng/typ2docx/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hhr2020 ];
    mainProgram = "typ2docx";
  };
}
