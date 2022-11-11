{ lib, fetchFromGitHub, buildDunePackage, easy-format }:

buildDunePackage rec {
  pname = "biniou";
  version = "1.2.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = pname;
    rev = version;
    sha256 = "0x2kiy809n1j0yf32l7hj102y628jp5jdrkbi3z7ld8jq04h1790";
  };

  propagatedBuildInputs = [ easy-format ];

  strictDeps = true;

  postPatch = ''
   patchShebangs .
  '';

  meta = {
    description = "Binary data format designed for speed, safety, ease of use and backward compatibility as protocols evolve";
    inherit (src.meta) homepage;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "bdump";
  };
}
