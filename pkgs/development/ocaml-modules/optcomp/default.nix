{ stdenv, lib, fetchurl, fetchpatch, ocaml, findlib, ocamlbuild, camlp4 }:

stdenv.mkDerivation {
  name = "ocaml-optcomp-1.6";
  src = fetchurl {
    url = "https://github.com/diml/optcomp/archive/1.6.tar.gz";
    sha256 = "0hhhb2gisah1h22zlg5iszbgqxdd7x85cwd57bd4mfkx9l7dh8jh";
  };

  patches =
    let inherit (lib) optional versionAtLeast; in
    optional (versionAtLeast ocaml.version "4.02") (fetchpatch {
      url = "https://github.com/diml/optcomp/commit/b7f809360c9794b383a4bc0492f6df381276b429.patch";
      sha256 = "1n095lk94jq1rwi0l24g2wbgms7249wdd31n0ji895dr6755s93y";
    })
  ;

  createFindlibDestdir = true;

  buildInputs = [ ocaml findlib ocamlbuild camlp4 ];

  configurePhase = ''
    cp ${./META} META
  '';

  buildPhase = ''
    ocamlbuild src/optcomp.cmxs src/optcomp.cma src/optcomp_o.native src/optcomp_r.native
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp _build/src/optcomp_o.native $out/bin/optcomp-o
    cp _build/src/optcomp_r.native $out/bin/optcomp-r
    ocamlfind install optcomp META _build/src/optcomp.{a,cma,cmxa,cmxs} _build/src/pa_optcomp.{cmi,cmx,mli}
  '';

  meta =  {
    homepage = "https://github.com/diml/optcomp";
    description = "Optional compilation for OCaml with cpp-like directives";
    license = lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      lib.maintainers.gal_bolle
    ];
  };

}
