{
  stdenv,
  gcc13Stdenv,
  lib,
  makeWrapper,
  fetchzip,
  ocaml,
  findlib,
  tcl,
  tk,
}:

let
  params = {
    "4.09" = {
      version = "8.06.7";
      sha256 = "1cqnxjv2dvw9csiz4iqqyx6rck04jgylpglk8f69kgybf7k7xk2h";
      stdenv = gcc13Stdenv;
    };
    "4.10" = {
      version = "8.06.8";
      sha256 = "0lfjc7lscq81ibqb3fcybdzs2r1i2xl7rsgi7linq46a0pcpkinw";
      stdenv = gcc13Stdenv;
    };
    "4.11" = {
      version = "8.06.9";
      sha256 = "1k42k3bjkf22gk39lwwzqzfhgjyhxnclslldrzpg5qy1829pbnc0";
      stdenv = gcc13Stdenv;
    };
    "4.12" = {
      version = "8.06.10";
      sha256 = "06cck7wijq4zdshzhxm6jyl8k3j0zglj2axsyfk6q1sq754zyf4a";
    };
    "4.13" = {
      version = "8.06.11";
      sha256 = "1zjpg9jvs6i9jvbgn6zgispwqiv8rxvaszxcx9ha9fax3wzhv9qy";
    };
    "4.14" = {
      version = "8.06.12";
      sha256 = "sha256:17fmb13l18isgwr38hg9r5a0nayf2hhw6acj5153cy1sygsdg3b5";
    };
    "5.0" = {
      version = "8.06.13";
      sha256 = "sha256-Vpf13g3DEWlUI5aypiowGp2fkQPK0cOGv2XiRUY/Ip4=";
    };
    "5.2" = {
      version = "8.06.14";
      sha256 = "sha256-eVSQetk+i3KObjHfsvnD615cIsq3aZ7IxycX42cuPIU=";
    };
    "5.3" = {
      version = "8.06.15";
      sha256 = "sha256-I/y5qr5sasCtlrwxL/Lex79rg0o4tzDMBmQY7MdpU2w=";
    };
  };
  param = {
    inherit stdenv;
    # Dummy version to let the `meta` attribute set evaluate
    version = "";
    sha256 = lib.fakeSha256;
  }
  // (params."${lib.versions.majorMinor ocaml.version}" or {
  }
  );
in

param.stdenv.mkDerivation {
  inherit (param) version;
  pname = "ocaml${ocaml.version}-labltk";

  src = fetchzip {
    url = "https://github.com/garrigue/labltk/archive/${param.version}.tar.gz";
    inherit (param) sha256;
  };

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    findlib
    makeWrapper
  ];
  buildInputs = [
    tcl
    tk
  ];

  configureFlags = [
    "--use-findlib"
    "--installbindir"
    "$(out)/bin"
  ];
  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];

  buildFlags = [
    "all"
    "opt"
  ];

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
    broken = !(params ? ${lib.versions.majorMinor ocaml.version});
  };
}
