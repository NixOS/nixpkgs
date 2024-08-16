{ lib, fetchurl, buildDunePackage, camlp-streams, easy-format }:

buildDunePackage rec {
  pname = "biniou";
  version = "1.2.2";

  src = fetchurl {
    url = "https://github.com/ocaml-community/biniou/releases/download/${version}/biniou-${version}.tbz";
    hash = "sha256-i/P/F80Oyy1rbR2UywjvCJ1Eyu+W6brmvmg51Cj6MY8=";
  };

  propagatedBuildInputs = [ camlp-streams easy-format ];

  meta = {
    description = "Binary data format designed for speed, safety, ease of use and backward compatibility as protocols evolve";
    homepage = "https://github.com/ocaml-community/biniou";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "bdump";
  };
}
