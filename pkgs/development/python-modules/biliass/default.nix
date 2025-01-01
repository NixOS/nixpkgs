{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "biliass";
  version = "2.0.0-beta.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    rev = "refs/tags/biliass@${version}";
    hash = "sha256-Clma0Ggkphk6F+K+h3TdMUX4WyWQorh9g2uAT4+Fc9I=";
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
    hash = "sha256-h/UOolWQ2k5krOZy/kPywpeiLyXWLzvNu+pcn97or1A=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
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
