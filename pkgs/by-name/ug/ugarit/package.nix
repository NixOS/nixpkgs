{
  lib,
  chickenPackages_4,
  z3,
}:

let
  eggs = import ./eggs.nix { inherit (chickenPackages_4) eggDerivation fetchegg; };
in

chickenPackages_4.eggDerivation rec {
  pname = "ugarit";
  version = "2.0";
  name = "${pname}-${version}";

  src = chickenPackages_4.fetchegg {
    inherit version;
    name = pname;
    sha256 = "1l5zkr6b8l5dw9p5mimbva0ncqw1sbvp3d4cywm1hqx2m03a0f1n";
  };

  buildInputs = with eggs; [
    aes
    crypto-tools
    matchable
    message-digest
    miscmacros
    parley
    pathname-expand
    posix-extras
    regex
    sha2
    sql-de-lite
    srfi-37
    ssql
    stty
    tiger-hash
    z3
  ];

  meta = {
    homepage = "https://www.kitten-technologies.co.uk/project/ugarit/";
    description = "Backup/archival system based around content-addressible storage";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
