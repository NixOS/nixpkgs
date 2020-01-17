{ stdenv, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "stdint";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "andrenth";
    repo = "ocaml-stdint";
    rev = version;
    sha256 = "19ccxs0vij81vyc9nqc9kbr154ralb9dgc2y2nr71a5xkx6xfn0y";
  };

  meta = {
    description = "Various signed and unsigned integers for OCaml";
    homepage = "https://github.com/andrenth/ocaml-stdint";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.gebner ];
  };
}
