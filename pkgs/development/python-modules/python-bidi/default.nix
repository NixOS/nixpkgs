{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-bidi";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MeirKriheli";
    repo = "python-bidi";
    rev = "refs/tags/v${version}";
    hash = "sha256-LrXt9qaXfy8Rn9HjU4YSTFT4WsqzwCgh0flcxXOTF6E=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-34R8T8cXiX1iRx/Zb51Eb/nf0wLpN38hz0VnsmzPzws=";
  };

  buildInputs = [ libiconv ];

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  preCheck = ''
    rm -rf bidi
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/MeirKriheli/python-bidi";
    description = "Pure python implementation of the BiDi layout algorithm";
    mainProgram = "pybidi";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ freezeboy ];
  };
}
