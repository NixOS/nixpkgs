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
  version = "0.6.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MeirKriheli";
    repo = "python-bidi";
    tag = "v${version}";
    hash = "sha256-fnKaKQz0qMHIXQj6tH8WcoxDk+TASl77VM/0BFEoKag=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-iUpY/gmbY+wIWwVd2ubMOnE/srBKDLHNchdteMUVmpE=";
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
    maintainers = [ ];
    license = lib.licenses.AND [
      lib.licenses.lgpl3Only
      lib.licenses.gpl3Only
    ];
  };
}
