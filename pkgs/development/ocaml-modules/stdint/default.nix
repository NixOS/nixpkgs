{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "stdint";
  version = "0.7.0";

  minimumOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "andrenth";
    repo = "ocaml-stdint";
    rev = version;
    sha256 = "05zpayczrq9668ci20b2ynsjcjp0wnzb1avfpsqzp4n0mb1mhgdl";
  };

  meta = {
    description = "Various signed and unsigned integers for OCaml";
    homepage = "https://github.com/andrenth/ocaml-stdint";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gebner ];
  };
}
