{ stdenv
, lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, cargo
, rustc
, setuptools-rust
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "gb-io";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "althonos";
    repo = "gb-io.py";
    rev = "v${version}";
    hash = "sha256-1B7BUJ8H+pTtmDtazfPfYtlXzL/x4rAHtRIFAAsSoWs=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src sourceRoot;
    name = "${pname}-${version}";
    hash = "sha256-lPnOFbEJgcaPPl9bTngugubhW//AUFp9RAjyiFHxC70=";
  };

<<<<<<< HEAD
  sourceRoot = src.name;
=======
  sourceRoot = "source";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "gb_io" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/althonos/gb-io.py";
    description = "A Python interface to gb-io, a fast GenBank parser written in Rust";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
