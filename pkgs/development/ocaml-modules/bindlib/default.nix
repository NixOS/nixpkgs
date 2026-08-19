{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  earley,
  timed,
}:

buildDunePackage (finalAttrs: {
  pname = "bindlib";
  version = "6.0.0";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "rlepigre";
    repo = "ocaml-bindlib";
    rev = finalAttrs.version;
    hash = "sha256-058yMbz9ExvgNG/kY9tPk70XSeVRSSKVg4n4F4fmPu4=";
  };

  checkInputs = [
    earley
    timed
  ];
  doCheck = true;

  meta = {
    homepage = "https://rlepigre.github.io/ocaml-bindlib";
    description = "Efficient binder representation in Ocaml";
    license = lib.licenses.gpl3;
    changelog = "https://github.com/rlepigre/ocaml-bindlib/raw/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
