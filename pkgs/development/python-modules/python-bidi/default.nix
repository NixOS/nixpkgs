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
  version = "0.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MeirKriheli";
    repo = "python-bidi";
    tag = "v${version}";
    hash = "sha256-8erpcrjAp/1ugPe6cOvjH2CVfy2/hO6xg+cfWWUbj0w=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-Oqtva9cTHAcuOXr/uPbqZczDbPVr0zeIEr5p6PoJ610=";
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
