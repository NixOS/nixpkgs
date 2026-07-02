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
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vlaci";
    repo = "pyperscan";
    rev = "v${version}";
    hash = "sha256-uGZ0XFxnZHSLEWcwoHVd+xMulDRqEIrQ5Lf7886GdlM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-9kKHLYD0tXMGJFhsCBgO/NpWB4J5QZh0qKIuI3PFn2c=";
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
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      tnias
      vlaci
    ];
  };
}
