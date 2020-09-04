{ lib, fetchurl, buildDunePackage }:

buildDunePackage rec {
  pname = "csexp";
  version = "1.3.1";

  useDune2 = true;

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/csexp/releases/download/${version}/csexp-${version}.tbz";
    sha256 = "0maihbqbqq9bwr0r1cv51r3m4hrkx9cf5wnxcz7rjgn13lcc9s49";
  };

  postPatch = ''
    substituteInPlace src/csexp.ml --replace Result.result Result.t
  '';

  meta = with lib; {
    homepage = "https://github.com/ocaml-dune/csexp";
    description = "Minimal support for Canonical S-expressions";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
