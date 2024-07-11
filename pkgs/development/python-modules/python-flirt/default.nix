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
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "lancelot";
    rev = "v${version}";
    hash = "sha256-J48tRgJw6JjUrcAQdRELFE50pyDptbmbgYbr+rAK/PA=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  format = "pyproject";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  buildAndTestSubdir = "pyflirt";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "zydis-3.1.3" = "sha256-X+aURjNfXGXO4eh6RJ3bi8Eb2kvF09I34ZHffvYjt9I=";
    };
  };

  pythonImportsCheck = [ "flirt" ];

  meta = with lib; {
    description = "Python library for parsing, compiling, and matching Fast Library Identification and Recognition Technology (FLIRT) signatures";
    homepage = "https://github.com/williballenthin/lancelot/tree/master/pyflirt";
    license = licenses.asl20;
    maintainers = with maintainers; [ sbruder ];
  };
}
