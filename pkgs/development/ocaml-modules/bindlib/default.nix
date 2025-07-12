{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  earley,
  timed,
}:

buildDunePackage rec {
  pname = "bindlib";
  version = "6.0.0";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "rlepigre";
    repo = "ocaml-${pname}";
    rev = version;
    hash = "sha256-058yMbz9ExvgNG/kY9tPk70XSeVRSSKVg4n4F4fmPu4=";
  };

  checkInputs = [
    earley
    timed
  ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://rlepigre.github.io/ocaml-bindlib";
    description = "Efficient binder representation in Ocaml";
    license = licenses.gpl3;
    changelog = "https://github.com/rlepigre/ocaml-bindlib/raw/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ bcdarwin ];
  };
}
