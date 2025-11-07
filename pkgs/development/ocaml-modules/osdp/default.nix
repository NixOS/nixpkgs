{
  lib,
  buildDunePackage,
  fetchurl,
  ocaml,
  findlib,
  zarith,
  ocplib-simplex,
  csdp,
  autoconf,
}:

lib.throwIf (lib.versionAtLeast ocaml.version "5.0")
  "osdp is not available for OCaml ${ocaml.version}"

  buildDunePackage
  {
    pname = "osdp";
    version = "1.1.1";

    src = fetchurl {
      url = "https://github.com/Embedded-SW-VnV/osdp/releases/download/v1.1.1/osdp-1.1.1.tgz";
      hash = "sha256-X7CS2g+MyQPDjhUCvFS/DoqcCXTEw8SCsSGED64TGKQ=";
    };

    preConfigure = ''
      autoconf
    '';

    nativeBuildInputs = [
      autoconf
      findlib
      csdp
    ];
    propagatedBuildInputs = [
      zarith
      ocplib-simplex
      csdp
    ];

    meta = {
      description = "OCaml Interface to SDP solvers";
      homepage = "https://github.com/Embedded-SW-VnV/osdp";
      license = lib.licenses.lgpl3Plus;
    };
  }
