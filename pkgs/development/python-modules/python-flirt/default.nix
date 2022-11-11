{ lib
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
}:

buildPythonPackage rec {
  pname = "python-flirt";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "lancelot";
    rev = "v${version}";
    sha256 = "sha256-FsdnWWfyQte7FDz5ldo+S+3IEtbOIODOeh1fHDP2/4s=";
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
