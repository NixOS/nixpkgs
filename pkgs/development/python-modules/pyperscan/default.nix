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
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "vlaci";
    repo = "pyperscan";
    rev = "v${version}";
    hash = "sha256-uGZ0XFxnZHSLEWcwoHVd+xMulDRqEIrQ5Lf7886GdlM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-a4jNofPIHoKwsD82y2hG2QPu+eM5D7FSGCm2nDo2cLA=";
  };

  nativeBuildInputs = with rustPlatform; [
    bindgenHook
    cargoSetupHook
    maturinBuildHook
  ];

  checkInputs = [ pytestCheckHook ];

  buildInputs = [ vectorscan ] ++ lib.optional stdenv.isDarwin libiconv;

  pythonImportsCheck = [ "pyperscan" ];

  meta = with lib; {
    description = "a hyperscan binding for Python, which supports vectorscan";
    homepage = "https://vlaci.github.io/pyperscan/";
    changelog = "https://github.com/vlaci/pyperscan/releases/tag/${src.rev}";
    platforms = platforms.unix;
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      tnias
      vlaci
    ];
  };
}
