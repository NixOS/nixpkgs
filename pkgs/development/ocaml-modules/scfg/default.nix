{
  lib,
  buildDunePackage,
  fetchzip,
  bos,
  cmdliner,
  fmt,
  fpath,
  menhir,
  menhirLib,
  prelude,
  sedlex,
  writableTmpDirAsHomeHook,
}:

buildDunePackage rec {
  pname = "scfg";
  version = "0.5";

  # upstream git repo is misconfigured and cannot be cloned
  src = fetchzip {
    url = "https://git.zapashcanon.fr/zapashcanon/scfg/archive/${version}.tar.gz";
    hash = "sha256-XyNVmI0W0B1JqR+uuojpHe9L5KKLhyoH8vN8+9i7Xcg=";
  };

  nativeBuildInputs = [
    menhir
  ];

  buildInputs = [
    cmdliner
  ];

  propagatedBuildInputs = [
    bos
    fmt
    fpath
    menhirLib
    prelude
    sedlex
  ];

  checkInputs = [
    writableTmpDirAsHomeHook
  ];

  doCheck = true;

  meta = {
    description = "Library to work with the scfg configuration file";
    homepage = "https://ocaml.org/p/scfg/";
    downloadPage = "https://git.zapashcanon.fr/zapashcanon/scfg";
    changelog = "https://git.zapashcanon.fr/zapashcanon/scfg/src/tag/${version}/CHANGES.md";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.ethancedwards8 ];
  };
}
