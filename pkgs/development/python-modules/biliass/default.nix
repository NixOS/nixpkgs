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
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yutto-dev";
    repo = "yutto";
    tag = "biliass@${version}";
    hash = "sha256-ZB18BQJRSwA/ERHjqmp+D39UqTvdYpbhwLjaizM5R2I=";
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
    hash = "sha256-gOYgYi8RlWBe0astv6D6/J7Ge20TM/19zJHwoCevpIo=";
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
