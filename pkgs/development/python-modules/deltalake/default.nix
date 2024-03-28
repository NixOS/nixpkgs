{ lib
, buildPythonPackage
, fetchFromGitHub
, pyarrow
, rustPlatform
, cmake
, perl
}:

buildPythonPackage rec {
  pname = "deltalake";
  version = "0.16.0";
  format = "pyproject";

  disabled = pyarrow.version < "14.0.1"; # We've removed pyarrow-hotfix, so versions before 14.0.1 are unsafe

  src = fetchFromGitHub {
    owner = "delta-io";
    repo = "delta-rs";
    rev = "refs/tags/python-v${version}";
    hash = "sha256-nvlP78M7cB3mmmzhbpM2+YOxJ5uSGso/UDEdQLenv8g=";
  };

  patches = [
    ./add-Cargo.lock.patch # Not included in source repo
    ./remove-pyarrow-hotfix.patch # no longer needed in pyarrow >= 14.0.1
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  buildAndTestSubdir = "python"; # Make maturin find python package

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    perl # openssl-sys needs this
  ] ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  propagatedBuildInputs = [
    pyarrow
  ];

  pythonImportsCheck = [ "deltalake" ];

  meta = with lib; {
    description = "A native Rust library for Delta Lake, with bindings into Python";
    homepage = "https://github.com/delta-io/delta-rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ harvidsen ];
  };
}
