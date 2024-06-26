{ buildPythonPackage
, Accelerate
, CoreFoundation
, Security
, fetchFromGitHub
, lib
, libiconv
, numpy
, protobuf
, pyarrow
, rustPlatform
, stdenv
}:

buildPythonPackage rec {
  pname = "pylance";
  version = "0.8.14";

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lance";
    rev = "refs/tags/v${version}";
    hash = "sha256-egLpWxkSE0YOvJvvgmfcqq5SpCs8G6mXDNsLglBTmc8=";
  };

  sourceRoot = "${src.name}/python";

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  buildInputs = lib.optionals stdenv.isDarwin [
    Accelerate
    CoreFoundation
    Security
    libiconv
    protobuf
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  format = "pyproject";

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  propagatedBuildInputs = [
    pyarrow
    numpy
  ];

  meta = {
    description = "Columnar data format for machine learning";
    homepage = "https://lancedb.github.io/lance/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ elohmeier ];
  };
}
