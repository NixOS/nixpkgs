{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
}:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.08")
  "ptime is not available for OCaml ${ocaml.version}"

  stdenv.mkDerivation
  (finalAttrs: {
    version = "1.1.0";
    pname = "ocaml${ocaml.version}-ptime";

    src = fetchurl {
      url = "https://erratique.ch/software/ptime/releases/ptime-${finalAttrs.version}.tbz";
      hash = "sha256-y/WxVFT7JxBeLDNAI+HhHY+TnXF4hw9cvo7SbfcBPrE=";
    };

    nativeBuildInputs = [
      findlib
      ocaml
      ocamlbuild
      topkg
    ];

    buildInputs = [
      topkg
    ];

    strictDeps = true;

    inherit (topkg) buildPhase installPhase;

    meta = {
      description = "POSIX time for OCaml";
      homepage = "https://erratique.ch/software/ptime";
      license = lib.licenses.isc;
      longDescription = ''
        Ptime has platform independent POSIX time support in pure OCaml.
        It provides a type to represent a well-defined range of POSIX timestamps
        with picosecond precision, conversion with date-time values, conversion
        with RFC 3339 timestamps and pretty printing to a human-readable,
        locale-independent representation.

        The additional Ptime_clock library provides access to a system POSIX clock
        and to the system's current time zone offset.

        Ptime is not a calendar library.
      '';
      maintainers = with lib.maintainers; [ sternenseemann ];
    };
  })
