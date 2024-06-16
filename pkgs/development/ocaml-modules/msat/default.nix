{ lib, fetchFromGitHub, buildDunePackage
, iter
, containers
, mdx
}:

buildDunePackage rec {
  pname = "msat";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "Gbury";
    repo = "mSAT";
    rev = "v${version}";
    hash = "sha256-ER7ZUejW+Zy3l2HIoFDYbR8iaKMvLZWaeWrOAAYXjG4=";
  };

  propagatedBuildInputs = [
    iter
  ];

  postPatch = ''
    substituteInPlace dune --replace mdx ocaml-mdx
  '';

  doCheck = true;
  checkInputs = [ containers ];
  nativeCheckInputs = [ mdx.bin ];

  meta = {
    description = "A modular sat/smt solver with proof output";
    homepage = "https://gbury.github.io/mSAT/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
