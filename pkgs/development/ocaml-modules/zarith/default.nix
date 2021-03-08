{ lib, stdenv, fetchurl
, ocaml, findlib, pkgconfig, perl
, gmp
}:

let source =
  if lib.versionAtLeast ocaml.version "4.02"
  then {
    version = "1.11";
    url = "https://github.com/ocaml/Zarith/archive/release-1.11.tar.gz";
    sha256 = "111n33flg4aq5xp5jfksqm4yyz6mzxx9ps9a4yl0dz8h189az5pr";
  } else {
    version = "1.3";
    url = "http://forge.ocamlcore.org/frs/download.php/1471/zarith-1.3.tgz";
    sha256 = "1mx3nxcn5h33qhx4gbg0hgvvydwlwdvdhqcnvfwnmf9jy3b8frll";
  };
in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-zarith-${version}";
  inherit (source) version;
  src = fetchurl { inherit (source) url sha256; };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml findlib perl ];
  propagatedBuildInputs = [ gmp ];

  patchPhase = "patchShebangs ./z_pp.pl";
  dontAddPrefix = true;
  configureFlags = [ "-installdir ${placeholder "out"}/lib/ocaml/${ocaml.version}/site-lib" ];

  preInstall = "mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs";

  meta = with lib; {
    description = "Fast, arbitrary precision OCaml integers";
    homepage    = "http://forge.ocamlcore.org/projects/zarith";
    license     = licenses.lgpl2;
    inherit (ocaml.meta) platforms;
    maintainers = with maintainers; [ thoughtpolice vbgl ];
  };
}
