{ stdenv, fetchurl, ocaml, findlib, pkgconfig, gmp, perl }:

assert stdenv.lib.versionAtLeast ocaml.version "3.12.1";

stdenv.mkDerivation rec {
  name = "zarith-${version}";
  version = "1.3";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1471/zarith-1.3.tgz;
    sha256 = "1mx3nxcn5h33qhx4gbg0hgvvydwlwdvdhqcnvfwnmf9jy3b8frll";
  };

  buildInputs = [ ocaml findlib pkgconfig perl ];
  propagatedBuildInputs = [ gmp ];

  patchPhase = ''
    substituteInPlace ./z_pp.pl --replace '/usr/bin/perl' '${perl}/bin/perl'
  '';
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
