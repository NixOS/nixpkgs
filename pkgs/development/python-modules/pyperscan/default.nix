{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  rustPlatform,
  pytestCheckHook,
  libiconv,
  vectorscan,
}:

buildPythonPackage rec {
  pname = "pyperscan";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vlaci";
    repo = "pyperscan";
    rev = "v${version}";
    hash = "sha256-8a7x6eF91grUNyZWBWsz/WL5WVrynElE5zLPHCaTp08=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-37EMRHp6X3CqZ/nIewUxWyJCSWXkT1lCyopzCn6M38w=";
  };

  nativeBuildInputs = with rustPlatform; [
    bindgenHook
    cargoSetupHook
    maturinBuildHook
  ];

  checkInputs = [ pytestCheckHook ];

  buildInputs = [ vectorscan ] ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  pythonImportsCheck = [ "pyperscan" ];

  meta = {
    description = "Hyperscan binding for Python, which supports vectorscan";
    homepage = "https://vlaci.github.io/pyperscan/";
    changelog = "https://github.com/vlaci/pyperscan/releases/tag/${src.rev}";
    platforms = lib.platforms.unix;
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      tnias
      vlaci
    ];
  };
}
