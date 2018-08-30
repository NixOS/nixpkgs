{ stdenv, fetchurl, ocaml, findlib, pkgconfig, gmp, perl }:

assert stdenv.lib.versionAtLeast ocaml.version "3.12.1";

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02"
  then {
    version = "1.7";
    url = https://github.com/ocaml/Zarith/archive/release-1.7.tar.gz;
    sha256 = "0fmblap5nsbqq0dab63d6b7lsxpc3snkgz7jfldi2qa4s1kbnhfn";
  } else {
    version = "1.3";
    url = http://forge.ocamlcore.org/frs/download.php/1471/zarith-1.3.tgz;
    sha256 = "1mx3nxcn5h33qhx4gbg0hgvvydwlwdvdhqcnvfwnmf9jy3b8frll";
  };
in

stdenv.mkDerivation rec {
  name = "zarith-${version}";
  inherit (param) version;

  src = fetchurl {
    inherit (param) url sha256;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml findlib perl ];
  propagatedBuildInputs = [ gmp ];

  patchPhase = "patchShebangs ./z_pp.pl";
  configurePhase = ''
    ./configure -installdir $out/lib/ocaml/${ocaml.version}/site-lib
  '';
  preInstall = "mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib";

  meta = with stdenv.lib; {
    description = "Fast, arbitrary precision OCaml integers";
    homepage    = "http://forge.ocamlcore.org/projects/zarith";
    license     = licenses.lgpl2;
    platforms   = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ thoughtpolice vbgl ];
  };
}
