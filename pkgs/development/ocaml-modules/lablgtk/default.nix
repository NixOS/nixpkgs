{ lib, stdenv, fetchurl, fetchFromGitHub, ocaml, findlib, pkg-config, gtk2, libgnomecanvas, gtksourceview }:

let param =
  let check = lib.versionAtLeast ocaml.version; in
  if check "4.06" then rec {
    version = "2.18.12";
    src = fetchFromGitHub {
      owner = "garrigue";
      repo = "lablgtk";
      rev = version;
      sha256 = "sha256:0asib87c42apwf1ln8541x6i3mvyajqbarifvz11in0mqn5k7g7h";
    };
    NIX_CFLAGS_COMPILE = null;
  } else if check "3.12" then {
    version = "2.18.5";
    src = fetchurl {
      url = "https://forge.ocamlcore.org/frs/download.php/1627/lablgtk-2.18.5.tar.gz";
      sha256 = "0cyj6sfdvzx8hw7553lhgwc0krlgvlza0ph3dk9gsxy047dm3wib";
    };
    # Workaround build failure on -fno-common toolchains like upstream
    # gcc-10. Otherwise build fails as:
    #   ld: ml_gtktree.o:(.bss+0x0): multiple definition of
    #     `ml_table_extension_events'; ml_gdkpixbuf.o:(.bss+0x0): first defined here
    NIX_CFLAGS_COMPILE = "-fcommon";
  } else throw "lablgtk is not available for OCaml ${ocaml.version}";
in

stdenv.mkDerivation {
  pname = "lablgtk";
  inherit (param) version src NIX_CFLAGS_COMPILE;

  nativeBuildInputs = [ pkg-config ocaml findlib ];
  buildInputs = [ gtk2 libgnomecanvas gtksourceview ];

  configureFlags = [ "--with-libdir=$(out)/lib/ocaml/${ocaml.version}/site-lib" ];
  buildFlags = [ "world" ];

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH
  '';

  dontStrip = true;

  meta = with lib; {
    description = "An OCaml interface to GTK";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ maggesi roconnor vbgl ];
    mainProgram = "lablgtk2";
    inherit (ocaml.meta) platforms;
  };
}
