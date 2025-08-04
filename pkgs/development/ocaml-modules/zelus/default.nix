{
  lib,
  stdenv,
  buildDunePackage,
  fetchFromGitHub,
  menhir,
  menhirLib,
}:

buildDunePackage rec {
  pname = "zelus";
  version = "2.2";

  minimalOCamlVersion = "4.08.1";

  src = fetchFromGitHub {
    owner = "INRIA";
    repo = "zelus";
    rev = version;
    hash = "sha256-NcGX343LProADtzJwlq1kmihLaya1giY6xv9ScvdgTA=";
  };

  # ./configure: cannot execute: required file not found
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchShebangs configure
  '';

  nativeBuildInputs = [
    menhir
  ];

  buildInputs = [
    menhirLib
  ];

  meta = {
    description = "Synchronous language with ODEs";
    homepage = "https://zelus.di.ens.fr";
    license = lib.licenses.inria-zelus;
    mainProgram = "zeluc";
    maintainers = with lib.maintainers; [ wegank ];
  };
}
