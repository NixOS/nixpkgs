{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "biliass";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    rev = "refs/tags/biliass@${version}";
    hash = "sha256-PlZD+988KdJqYC1I1K7i+YAH1Tzr6zfXcJFR/M4mQRA=";
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
    hash = "sha256-DMKUbJSVME5siSPybdO5bOluPn3obVq1/6822uoSsDQ=";
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
