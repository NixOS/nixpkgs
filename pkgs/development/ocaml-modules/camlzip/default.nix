{stdenv, fetchurl, zlib, ocaml, findlib}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  param =
    if stdenv.lib.versionAtLeast ocaml_version "4.02"
    then {
      version = "1.06";
      url = "1616";
      sha256 = "0m6gyjw46w3qnhxfsyqyag42znl5lwargks7w7rfchr9jzwpff68";
      patch = ./makefile_1_06.patch;
      installTargets = "install-findlib";
    } else {
      version = "1.05";
      url = "1037";
      sha256 = "930b70c736ab5a7ed1b05220102310a0a2241564786657abe418e834a538d06b";
      patch = ./makefile_1_05.patch;
      installTargets = "install";
    };
in

stdenv.mkDerivation {
  name = "camlzip-${param.version}";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/${param.url}/camlzip-${param.version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [zlib ocaml findlib];

  patches = [ param.patch ];

  createFindlibDestdir = true;

  postPatch = ''
    substitute ${./META} META --subst-var-by VERSION "${param.version}"
    substituteInPlace Makefile \
      --subst-var-by ZLIB_LIBDIR "${zlib.out}/lib" \
      --subst-var-by ZLIB_INCLUDE "${zlib.dev}/include"
  '';

  buildFlags = "all allopt";

  inherit (param) installTargets;

  postInstall = ''
    ln -s $out/lib/ocaml/${ocaml_version}/site-lib/{,caml}zip
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
      stdenv.lib.maintainers.z77z
    ];
  };
}
