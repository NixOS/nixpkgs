{ lib, buildDunePackage, ocaml, fetchurl, alcotest }:

buildDunePackage rec {
  pname = "terminal_size";
  version = "0.1.4";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/cryptosense/terminal_size/releases/download/v${version}/terminal_size-v${version}.tbz";
    sha256 = "fdca1fee7d872c4a8e5ab003d9915b6782b272e2a3661ca877f2d78dd25371a7";
  };

  checkInputs = [ alcotest ];
  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = with lib; {
    description = "Get the dimensions of the terminal";
    homepage = "https://github.com/cryptosense/terminal_size";
    license = licenses.bsd2;
    maintainers = [ maintainers.sternenseemann ];
  };
}
