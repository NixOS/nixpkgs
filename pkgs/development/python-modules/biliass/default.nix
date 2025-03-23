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
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    tag = "biliass@${version}";
    hash = "sha256-IrzFjjMNuD5UgdccHxIxZoeZpM1PGtVQRTWHOocnmAU=";
  };

  sourceRoot = "source/packages/biliass";
  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      ;
    sourceRoot = "${sourceRoot}/${cargoRoot}";
    hash = "sha256-yR2eVsomepIh9ILon7PrAj2EBgI/vwN3JgRSR/3R1Mk=";
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
