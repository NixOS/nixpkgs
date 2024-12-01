{ lib, fetchFromGitHub, buildDunePackage, logs, zarith }:

buildDunePackage rec {
  pname = "ocplib-simplex";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fLTht+TlyJIsIAsRLmmkFKsnbSeW3BgyAyURFdnGfko=";
  };

  propagatedBuildInputs = [ logs zarith ];

  doCheck = true;

  meta = {
    description = "OCaml library implementing a simplex algorithm, in a functional style, for solving systems of linear inequalities";
    homepage = "https://github.com/OCamlPro-Iguernlala/ocplib-simplex";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
