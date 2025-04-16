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
  version = "0.9.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "lancelot";
    rev = "v${version}";
    hash = "sha256-IgkfUkVsJyAsqH+L9GBdTQI1ure4k8mVLLWHj7AFDj8=";
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

  meta = with lib; {
    description = "Python library for parsing, compiling, and matching Fast Library Identification and Recognition Technology (FLIRT) signatures";
    homepage = "https://github.com/williballenthin/lancelot/tree/master/pyflirt";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
  };
}
