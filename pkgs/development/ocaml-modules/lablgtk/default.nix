{ stdenv, fetchurl, ocaml, findlib, pkgconfig, gtk2, libgnomecanvas, libglade, gtksourceview }:

let param =
  let check = stdenv.lib.versionAtLeast ocaml.version; in
  if check "4.06" then {
    version = "2.18.8";
    url = "https://github.com/garrigue/lablgtk/releases/download/lablgtk2188/lablgtk-2.18.8.tar.gz";
    sha256 = "1qsd9nv96fxddc8zayqiqxw9hcyf29axckqg100fm2brs2prpxci";
  } else if check "3.12" then {
    version = "2.18.5";
    url = https://forge.ocamlcore.org/frs/download.php/1627/lablgtk-2.18.5.tar.gz;
    sha256 = "0cyj6sfdvzx8hw7553lhgwc0krlgvlza0ph3dk9gsxy047dm3wib";
  } else throw "lablgtk is not available for OCaml ${ocaml.version}";
in

stdenv.mkDerivation {
  pname = "lablgtk";
  inherit (param) version;

  src = fetchurl {
    inherit (param) url sha256;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ocaml findlib gtk2 libgnomecanvas libglade gtksourceview ];

  configureFlags = [ "--with-libdir=$(out)/lib/ocaml/${ocaml.version}/site-lib" ];
  buildFlags = [ "world" ];

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      maggesi roconnor vbgl
    ];
    homepage = http://lablgtk.forge.ocamlcore.org/;
    description = "An OCaml interface to GTK";
    license = licenses.lgpl21Plus;
  };
}
