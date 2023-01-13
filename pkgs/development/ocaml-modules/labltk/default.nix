{ stdenv, lib, makeWrapper, fetchzip, Cocoa, ocaml, findlib, tcl, tk }:

let
 params =
  let mkNewParam = { version, sha256, rev ? version }: {
    inherit version;
    src = fetchzip {
      url = "https://github.com/garrigue/labltk/archive/${rev}.tar.gz";
      inherit sha256;
    };
  }; in
 rec {
  "4.06" = mkNewParam {
    version = "8.06.4";
    rev = "labltk-8.06.4";
    sha256 = "03xwnnnahb2rf4siymzqyqy8zgrx3h26qxjgbp5dh1wdl7n02c7g";
  };
  "4.07" = mkNewParam {
    version = "8.06.5";
    rev = "1b71e2c6f3ae6847d3d5e79bf099deb7330fb419";
    sha256 = "02vchmrm3izrk7daldd22harhgrjhmbw6i1pqw6hmfmrmrypypg2";
  };
  _8_06_7 = mkNewParam {
    version = "8.06.7";
    sha256 = "1cqnxjv2dvw9csiz4iqqyx6rck04jgylpglk8f69kgybf7k7xk2h";
  };
  "4.08" = _8_06_7;
  "4.09" = _8_06_7;
  "4.10" = mkNewParam {
    version = "8.06.8";
    sha256 = "0lfjc7lscq81ibqb3fcybdzs2r1i2xl7rsgi7linq46a0pcpkinw";
  };
  "4.11" = mkNewParam {
    version = "8.06.9";
    sha256 = "1k42k3bjkf22gk39lwwzqzfhgjyhxnclslldrzpg5qy1829pbnc0";
  };
  "4.12" = mkNewParam {
    version = "8.06.10";
    sha256 = "06cck7wijq4zdshzhxm6jyl8k3j0zglj2axsyfk6q1sq754zyf4a";
  };
  "4.13" = mkNewParam {
    version = "8.06.11";
    sha256 = "1zjpg9jvs6i9jvbgn6zgispwqiv8rxvaszxcx9ha9fax3wzhv9qy";
  };
  "4.14" = mkNewParam {
    version = "8.06.12";
    sha256 = "sha256:17fmb13l18isgwr38hg9r5a0nayf2hhw6acj5153cy1sygsdg3b5";
  };
  "5.0" = mkNewParam {
    version = "8.06.13";
    sha256 = "sha256-Vpf13g3DEWlUI5aypiowGp2fkQPK0cOGv2XiRUY/Ip4=";
  };
 };
 param = params . ${lib.versions.majorMinor ocaml.version}
   or (throw "labltk is not available for OCaml ${ocaml.version}");
in

stdenv.mkDerivation rec {
  inherit (param) version src;
  pname = "ocaml${ocaml.version}-labltk";

  nativeBuildInputs = [ ocaml findlib makeWrapper ];
  buildInputs = [ tcl tk ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  configureFlags = [ "--use-findlib" "--installbindir" "$(out)/bin" ];
  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

  buildFlags = [ "all" "opt" ];

  createFindlibDestdir = true;

  postInstall = ''
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
    mv $OCAMLFIND_DESTDIR/labltk/dlllabltk.so $OCAMLFIND_DESTDIR/stublibs/
    for p in $out/bin/*
    do
      wrapProgram $p --set CAML_LD_LIBRARY_PATH $OCAMLFIND_DESTDIR/stublibs
    done
  '';

  meta = {
    description = "OCaml interface to Tcl/Tk, including OCaml library explorer OCamlBrowser";
    homepage = "http://labltk.forge.ocamlcore.org/";
    license = lib.licenses.lgpl21;
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
