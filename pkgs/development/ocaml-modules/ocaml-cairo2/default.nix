{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, pkgconfig, cairo, lablgtk, gtk2,
  enableGtkSupport ? true # Whether to compile with support for Gtk
                          # integration (library file cairo2_gtk). Depends
                          # on lablgtk and gtk2.
}:

let
  inherit (stdenv.lib) optionals;
  pname = "ocaml-cairo2";
  version = "0.4.6";
in

stdenv.mkDerivation {

  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/1279/cairo2-0.4.6.tar.gz";
    sha256 = "1lc1iv5yz49avbc0wbrw9nrx8dn0c35r7cykivjln1zc2fwscf7w";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml findlib ocamlbuild cairo ]
                ++ optionals enableGtkSupport [ gtk2 ];

  # lablgtk2 is marked as a propagated build input since loading the
  # cairo.lablgtk2 package from the toplevel tries to load lablgtk2 as
  # well.
  propagatedBuildInputs = optionals enableGtkSupport [ lablgtk ];

  createFindlibDestdir = true;

  configurePhase = "ocaml setup.ml -configure --prefix $out"
                 + (if enableGtkSupport then " --enable-lablgtk2"
                                        else " --disable-lablgtk2");

  buildPhase = "ocaml setup.ml -build";

  installPhase = "ocaml setup.ml -install";

  meta = with stdenv.lib; {
    homepage = http://forge.ocamlcore.org/projects/cairo;
    description = "Binding to Cairo, a 2D Vector Graphics Library";
    longDescription = ''
      This is a binding to Cairo, a 2D graphics library with support for
      multiple output devices. Currently supported output targets include
      the X Window System, Quartz, Win32, image buffers, PostScript, PDF,
      and SVG file output.
    '';
    license = licenses.lgpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.jirkamarsik ];
  };
}
