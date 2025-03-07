{ lib, fetchFromGitHub, fetchpatch, buildDunePackage, logs, zarith }:

buildDunePackage rec {
  pname = "ocplib-simplex";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fLTht+TlyJIsIAsRLmmkFKsnbSeW3BgyAyURFdnGfko=";
  };

  # Fix tests with dune 3.17.0
  # See https://github.com/OCamlPro/ocplib-simplex/issues/35
  patches = (fetchpatch {
    url = "https://github.com/OCamlPro/ocplib-simplex/commit/456a744bddd397daade7959d4a49cfadafdadd33.patch";
    hash = "sha256-tQUXOoRGe1AIzHcm6j2MopROxn75OE9YUP+CwcKUbVg=";
  });

  propagatedBuildInputs = [ logs zarith ];

  doCheck = true;

  meta = {
    description = "OCaml library implementing a simplex algorithm, in a functional style, for solving systems of linear inequalities";
    homepage = "https://github.com/OCamlPro-Iguernlala/ocplib-simplex";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
