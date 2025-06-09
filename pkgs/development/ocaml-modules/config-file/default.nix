{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  camlp4,
}:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "config-file is not available for OCaml ${ocaml.version}"

  stdenv.mkDerivation
  rec {
    pname = "ocaml-config-file";
    version = "1.2";

    src = fetchurl {
      url = "https://forge.ocamlcore.org/frs/download.php/1387/config-file-${version}.tar.gz";
      sha256 = "1b02yxcnsjhr05ssh2br2ka4hxsjpdw34ldl3nk33wfnkwk7g67q";
    };

    nativeBuildInputs = [
      ocaml
      findlib
      camlp4
    ];

    strictDeps = true;

    createFindlibDestdir = true;

    meta = {
      homepage = "http://config-file.forge.ocamlcore.org/";
      platforms = ocaml.meta.platforms or [ ];
      description = "OCaml library used to manage the configuration file(s) of an application";
      license = lib.licenses.lgpl2Plus;
      maintainers = with lib.maintainers; [ vbgl ];
    };
  }
