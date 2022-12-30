{ lib
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
}:

buildPythonPackage rec {
  pname = "python-flirt";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "lancelot";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-J48tRgJw6JjUrcAQdRELFE50pyDptbmbgYbr+rAK/PA=";
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  format = "pyproject";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildAndTestSubdir = "pyflirt";

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "zydis-3.1.1" = "sha256-/L28cBTCg/S7onDQXnqUoB5udoEO/depmxDUcnfIQEw=";
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
