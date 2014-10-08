{stdenv, fetchurl, ocaml, findlib, pkgconfig, gtk, libgnomecanvas, libglade, gtksourceview, camlp4}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "lablgtk";
  version = "2.18.2";
in

assert stdenv.lib.versionAtLeast ocaml_version "3.12";

stdenv.mkDerivation {
  name = "${pname}-${version}";
  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1456/lablgtk-2.18.2.tar.gz;
    sha256 = "0f9rs4av0v7p5k8hifcq4b49xx8jmmfch3sdk9pij8a8jfgwxvfy";
  };

  buildInputs = [ocaml findlib pkgconfig gtk libgnomecanvas libglade gtksourceview camlp4];

  configureFlags = "--with-libdir=$(out)/lib/ocaml/${ocaml_version}/site-lib";
  buildFlags = "world";

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml_version}/site-lib
    export OCAMLPATH=$out/lib/ocaml/${ocaml_version}/site-lib/:$OCAMLPATH
  '';

  meta = with stdenv.lib; {
    platforms = ocaml.meta.platforms;
    maintainers = with maintainers; [
      z77z roconnor vbgl
    ];
    homepage = http://lablgtk.forge.ocamlcore.org/;
    description = "An OCaml interface to gtk+";
    license = licenses.lgpl21Plus;
  };
}
