{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  fetchpatch,
  alcotest,
  cmdliner,
  ppx_deriving,
  ppxlib,
  result,
  gitUpdater,
}:

buildDunePackage rec {
  pname = "ppx_deriving_cmdliner";
  version = "0.6.1";

  minimalOCamlVersion = "4.11";

  src = fetchFromGitHub {
    owner = "hammerlab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/22KLQnxu3e2ZSca6ZLxTJDfv/rsmgCUkJnZC0RwRi8";
  };

  patches = [
    # Ppxlib.0.26.0 compatibility
    # remove when a new version is released
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/hammerlab/ppx_deriving_cmdliner/pull/50.patch";
      sha256 = "sha256-FfUfEAsyobwZ99+s5sFAaCE6Xgx7jLr/q79OxDbGcvQ=";
    })
  ];

  propagatedBuildInputs = [
    cmdliner
    ppx_deriving
    ppxlib
    result
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Ppx_deriving plugin for generating command line interfaces from types for OCaml";
    homepage = "https://github.com/hammerlab/ppx_deriving_cmdliner";
    license = licenses.asl20;
    maintainers = [ maintainers.romildo ];
    broken = lib.versionAtLeast ppxlib.version "0.36";
  };
}
