{stdenv, fetchurl, ocaml, findlib, pkgconfig, gtk, libgnomecanvas, libglade, gtksourceview, camlp4}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  pname = "lablgtk";
  version = "2.18.3";
in

assert stdenv.lib.versionAtLeast ocaml_version "3.12";

stdenv.mkDerivation {
  name = "${pname}-${version}";
  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1479/lablgtk-2.18.3.tar.gz;
    sha256 = "1bybn3jafxf4cx25zvn8h2xj9agn1xjbn7j3ywxxqx6az7rfnnwp";
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
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = with maintainers; [
      z77z roconnor vbgl
    ];
    homepage = http://lablgtk.forge.ocamlcore.org/;
    description = "An OCaml interface to gtk+";
    license = licenses.lgpl21Plus;
  };
}
