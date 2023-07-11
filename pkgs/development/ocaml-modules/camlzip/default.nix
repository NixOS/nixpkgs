{lib, stdenv, fetchurl, zlib, ocaml, findlib}:

let
  common = {
      patches = [];
      postPatchInit = ''
        cp META-zip META-camlzip
        echo 'directory="../zip"' >> META-camlzip
      '';
  };
  param =
    if lib.versionAtLeast ocaml.version "4.07"
    then common // {
      version = "1.11";
      url = "https://github.com/xavierleroy/camlzip/archive/rel111.tar.gz";
      sha256 = "sha256-/7vF3j4cE9wOWScjdtIy0u3pGzJ1UQY9R/3bdPHV7Tc=";
    } else if lib.versionAtLeast ocaml.version "4.02"
    then common // {
      version = "1.10";
      url = "https://github.com/xavierleroy/camlzip/archive/rel110.tar.gz";
      sha256 = "X0YcczaQ3lFeJEiTIgjSSZ1zi32KFMtmZsP0FFpyfbI=";
    } else {
      version = "1.05";
      download_id = "1037";
      url = "http://forge.ocamlcore.org/frs/download.php/${param.download_id}/camlzip-${param.version}.tar.gz";
      sha256 = "930b70c736ab5a7ed1b05220102310a0a2241564786657abe418e834a538d06b";
      patches = [./makefile_1_05.patch];
      postPatchInit = ''
        substitute ${./META} META --subst-var-by VERSION "${param.version}"
      '';
    };
in

stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-camlzip";
  version = param.version;

  src = fetchurl {
    inherit (param) url;
    inherit (param) sha256;
  };

  nativeBuildInputs = [ ocaml findlib ];

  propagatedBuildInputs = [zlib];

  strictDeps = true;

  inherit (param) patches;

  createFindlibDestdir = true;

  postPatch = param.postPatchInit + ''
    substituteInPlace Makefile \
      --subst-var-by ZLIB_LIBDIR "${zlib.out}/lib" \
      --subst-var-by ZLIB_INCLUDE "${zlib.dev}/include"
  '';

  buildFlags = [ "all" "allopt" ];

  postInstall = ''
    ln -s $out/lib/ocaml/${ocaml.version}/site-lib/{,caml}zip
  '';

  meta = with lib; {
    homepage = "http://cristal.inria.fr/~xleroy/software.html#camlzip";
    description = "A library for handling ZIP and GZIP files in OCaml";
    longDescription = ''
      This Objective Caml library provides easy access to compressed files in
      ZIP and GZIP format, as well as to Java JAR files.  It provides functions
      for reading from and writing to compressed files in these formats.
    '';
    license = "LGPL+linking exceptions";
    inherit (ocaml.meta) platforms;
    maintainers = with maintainers; [ maggesi ];
  };
}
