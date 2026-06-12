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
  version = "0.6.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MeirKriheli";
    repo = "python-bidi";
    tag = "v${version}";
    hash = "sha256-IFLuUpOTZgI9KoZmeQKMlNPRQizXuaRhE0k/jk0fZvs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-YW5BSnb4wSCTfQZ4ytiAxDmzrkyDAwTt4T1YzcZeiNY=";
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
    hasNoMaintainersButDependents = true;
  };
}
