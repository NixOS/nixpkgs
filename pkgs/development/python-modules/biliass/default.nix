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
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    tag = "biliass@${version}";
    hash = "sha256-PlZD+988KdJqYC1I1K7i+YAH1Tzr6zfXcJFR/M4mQRA=";
  };

  sourceRoot = "${src.name}/packages/biliass";
  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-P9Rskt4dXTCF64uIsd0kAIrg9Zj2nIyHuUSbNpysSrE=";
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
