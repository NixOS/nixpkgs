{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  ocaml,
  findlib,
  pkg-config,
  gtk2,
  libgnomecanvas,
  gtksourceview,
  camlp-streams,
  gnumake42,
}:

let
  param =
    let
      check = lib.versionAtLeast ocaml.version;
    in
    if check "4.06" then
      rec {
        version = "2.18.13";
        src = fetchFromGitHub {
          owner = "garrigue";
          repo = "lablgtk";
          rev = version;
          sha256 = "sha256-69Svno0qLaUifMscnVuPUJlCo9d8Lee+1qiYx34G3Po=";
        };
        env = { };
        buildInputs = [ camlp-streams ];
      }
    else if check "3.12" then
      {
        version = "2.18.5";
        src = fetchurl {
          url = "https://forge.ocamlcore.org/frs/download.php/1627/lablgtk-2.18.5.tar.gz";
          sha256 = "0cyj6sfdvzx8hw7553lhgwc0krlgvlza0ph3dk9gsxy047dm3wib";
        };
        # Workaround build failure on -fno-common toolchains like upstream
        # gcc-10. Otherwise build fails as:
        #   ld: ml_gtktree.o:(.bss+0x0): multiple definition of
        #     `ml_table_extension_events'; ml_gdkpixbuf.o:(.bss+0x0): first defined here
        env.NIX_CFLAGS_COMPILE = "-fcommon";
      }
    else
      throw "lablgtk is not available for OCaml ${ocaml.version}";
in

stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-lablgtk";
  inherit (param) version src env;

  # gnumake42: https://github.com/garrigue/lablgtk/issues/162
  nativeBuildInputs = [
    pkg-config
    ocaml
    findlib
    gnumake42
  ];
  buildInputs = [
    gtk2
    libgnomecanvas
    gtksourceview
  ] ++ param.buildInputs or [ ];

  configureFlags = [ "--with-libdir=$(out)/lib/ocaml/${ocaml.version}/site-lib" ];
  buildFlags = [ "world" ];

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH
  '';

  dontStrip = true;

  meta = with lib; {
    description = "OCaml interface to GTK";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [
      maggesi
      roconnor
      vbgl
    ];
    mainProgram = "lablgtk2";
    inherit (ocaml.meta) platforms;
  };
}
