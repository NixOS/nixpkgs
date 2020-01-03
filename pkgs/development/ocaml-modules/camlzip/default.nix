{stdenv, fetchurl, zlib, ocaml, findlib}:

let
  param =
    if stdenv.lib.versionAtLeast ocaml.version "4.02"
    then {
      version = "1.07";
      url = "https://github.com/xavierleroy/camlzip/archive/rel107.tar.gz";
      sha256 = "1pdz3zyiczm6c46zfgag2frwq3ljlq044p3a2y4wm2wb4pgz8k9g";
      patches = [];
      installTargets = [ "install-findlib" ];
    } else {
      version = "1.05";
      download_id = "1037";
      url = "http://forge.ocamlcore.org/frs/download.php/${param.download_id}/camlzip-${param.version}.tar.gz";
      sha256 = "930b70c736ab5a7ed1b05220102310a0a2241564786657abe418e834a538d06b";
      patches = [./makefile_1_05.patch];
      installTargets = [ "install" ];
    };
in

stdenv.mkDerivation {
  name = "camlzip-${param.version}";

  src = fetchurl {
    inherit (param) url;
    inherit (param) sha256;
  };

  buildInputs = [ocaml findlib];

  propagatedBuildInputs = [zlib];

  inherit (param) patches;

  createFindlibDestdir = true;

  postPatch = ''
    substitute ${./META} META --subst-var-by VERSION "${param.version}"
    substituteInPlace Makefile \
      --subst-var-by ZLIB_LIBDIR "${zlib.out}/lib" \
      --subst-var-by ZLIB_INCLUDE "${zlib.dev}/include"
  '';

  buildFlags = [ "all" "allopt" ];

  inherit (param) installTargets;

  postInstall = ''
    ln -s $out/lib/ocaml/${ocaml.version}/site-lib/{,caml}zip
  '';

  meta = {
    homepage = "http://cristal.inria.fr/~xleroy/software.html#camlzip";
    description = "A library for handling ZIP and GZIP files in OCaml";
    longDescription = ''
      This Objective Caml library provides easy access to compressed files in
      ZIP and GZIP format, as well as to Java JAR files.  It provides functions
      for reading from and writing to compressed files in these formats.
    '';
    license = "LGPL+linking exceptions";
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.maggesi
    ];
  };
}
