{
  lib,
  python3,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,

  pkg-config,
  openssl,

  pandoc,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "typ2docx";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sghng";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8ixEF84aTeZT3sK2Y6+76MY5LnqIMO3KTkkWtbV05xw=";
  };

  lockFile = fetchurl {
    url = "https://github.com/sghng/typ2docx/releases/download/v${version}/Cargo.lock";
    hash = "sha256-SWtOT1wFy4Wz90ICMREOF2AGwp7zZ92D6SoKC7faxsk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      postPatch
      ;
    hash = "sha256-F9GnAFtceQEoqhImfZhyHTV6Ou8ciIhiuElIuMQnzIc=";
  };

  postPatch = ''
    ln -s ${lockFile} Cargo.lock
  '';

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    pkg-config
  ];

  build-system = with python3.pkgs; [
    uv-build
  ];

  dependencies = with python3.pkgs; [
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

  meta = {
    description = "A bespoke (and esoteric) but effective solution for converting Typst project to DOCX";
    homepage = "https://github.com/sghng/typ2docx";
    changelog = "https://github.com/sghng/typ2docx/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hhr2020 ];
    mainProgram = "typ2docx";
  };
}
