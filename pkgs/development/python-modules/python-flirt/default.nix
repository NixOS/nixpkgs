{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
}:

buildPythonPackage rec {
  pname = "python-flirt";
  version = "0.9.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "lancelot";
    rev = "v${version}";
    hash = "sha256-fZZTEBkpCE5L4efcNGzAuxCWgOSqc2r77F5U6kpMU6M=";
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ar-0.9.0" = "sha256-eyi1MlhJVvsiBOsetDHXFpdk+ABeZo/fVXNyvc5mw9s=";
    };
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  buildAndTestSubdir = "pyflirt";

  pythonImportsCheck = [ "flirt" ];

  meta = {
    description = "Python library for parsing, compiling, and matching Fast Library Identification and Recognition Technology (FLIRT) signatures";
    homepage = "https://github.com/williballenthin/lancelot/tree/master/pyflirt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sbruder ];
  };
}
