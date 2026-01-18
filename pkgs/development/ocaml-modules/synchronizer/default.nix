{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  prelude,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "synchronizer";
  version = "0.2";

  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "synchronizer";
    tag = finalAttrs.version;
    hash = "sha256-0XtPHpDlyH1h8W2ZlRvJbZjCN9WP5mzk2N01WFd8eLQ=";
  };

  propagatedBuildInputs = [
    prelude
  ];

  checkInputs = [
    alcotest
  ];

  meta = {
    homepage = "https://github.com/OCamlPro/synchronizer";
    description = "Synchronizer to make datastructures thread-safe";
    changelog = "https://raw.githubusercontent.com/OCamlPro/synchronizer/${finalAttrs.src.rev}/CHANGES.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
