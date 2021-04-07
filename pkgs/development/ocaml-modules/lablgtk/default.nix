{ lib, stdenv, fetchurl, fetchFromGitHub, ocaml, findlib, pkg-config, gtk2, libgnomecanvas, libglade, gtksourceview }:

let param =
  let check = lib.versionAtLeast ocaml.version; in
  if check "4.06" then rec {
    version = "2.18.10";
    src = fetchFromGitHub {
      owner = "garrigue";
      repo = "lablgtk";
      rev = version;
      sha256 = "0w8cdfcv2wc19sd3qzj3qq77qc6rbnbynsz02gzbl15kgrvgrfxi";
    };
  } else if check "3.12" then {
    version = "2.18.5";
    src = fetchurl {
      url = "https://forge.ocamlcore.org/frs/download.php/1627/lablgtk-2.18.5.tar.gz";
      sha256 = "0cyj6sfdvzx8hw7553lhgwc0krlgvlza0ph3dk9gsxy047dm3wib";
    };
  } else throw "lablgtk is not available for OCaml ${ocaml.version}";
in

stdenv.mkDerivation {
  pname = "lablgtk";
  inherit (param) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ocaml findlib gtk2 libgnomecanvas libglade gtksourceview ];

  configureFlags = [ "--with-libdir=$(out)/lib/ocaml/${ocaml.version}/site-lib" ];
  buildFlags = [ "world" ];

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH
  '';

  dontStrip = true;

  meta = with lib; {
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [
      maggesi roconnor vbgl
    ];
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    description = "An OCaml interface to GTK";
    license = licenses.lgpl21Plus;
  };
}
