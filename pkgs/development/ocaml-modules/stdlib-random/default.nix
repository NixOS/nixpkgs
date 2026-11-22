{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  cppo,
  version ? "1.2.0",
}:

buildDunePackage {
  pname = "stdlib-random";
  inherit version;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "stdlib-random";
    tag = version;
    hash = "sha256-rtdPQ/zXdywjhjLi60nMe1rks2yLP2TH4xUg5z/Bpjk=";
  };

  nativeBuildInputs = [ cppo ];

  meta = {
    license = lib.licenses.lgpl21Only;
    description = "Compatibility library for Random number generation";
    homepage = "https://github.com/ocaml/stdlib-random";
    maintainers = [ lib.maintainers.vbgl ];
  };

}
