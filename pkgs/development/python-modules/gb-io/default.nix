{ stdenv
, lib
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
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
    sha256 = "sha256-1B7BUJ8H+pTtmDtazfPfYtlXzL/x4rAHtRIFAAsSoWs=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src sourceRoot;
    name = "${pname}-${version}";
    sha256 = "sha256-lPnOFbEJgcaPPl9bTngugubhW//AUFp9RAjyiFHxC70=";
  };

  sourceRoot = "source";

  nativeBuildInputs = [ setuptools-rust ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  checkInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "gb_io" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/althonos/gb-io.py";
    description = "A Python interface to gb-io, a fast GenBank parser written in Rust";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ dlesl ];
  };
}
