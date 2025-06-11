{
  lib,
  fetchFromGitHub,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "bitv";
  version = "2.0";
  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "backtracking";
    repo = "bitv";
    tag = version;
    hash = "sha256-llfbdrvxrz6323G2LBAtKaXOrHQriFzaz3ulvFVhH6s=";
  };

  meta = {
    description = "Bit vector library for OCaml";
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/backtracking/bitv";
    changelog = "https://github.com/backtracking/bitv/releases/tag/${version}";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
