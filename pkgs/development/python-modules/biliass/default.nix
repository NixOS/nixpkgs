{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  libiconv,
}:

buildPythonPackage rec {
  pname = "biliass";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    rev = "refs/tags/biliass@${version}";
    hash = "sha256-Pn6z4iDxNcLVoY4xk7v0zc8hmajWEaOYFDEw5HEYxl4=";
  };

  sourceRoot = "source/packages/biliass";
  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit
      pname
      version
      src
      ;
    sourceRoot = "${sourceRoot}/${cargoRoot}";
    hash = "sha256-7jv/Q98qyn2xnv4rNK9ifGhxo9n3X90iF9CTyqc6sHU=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  doCheck = false; # test artifacts missing

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "biliass" ];

  meta = with lib; {
    homepage = "https://github.com/yutto-dev/biliass";
    description = "Convert Bilibili XML/protobuf danmaku to ASS subtitle";
    mainProgram = "biliass";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ linsui ];
  };
}
