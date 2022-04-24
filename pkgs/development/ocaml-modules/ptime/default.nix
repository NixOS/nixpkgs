{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg, js_of_ocaml
, jsooSupport ? true
}:

stdenv.mkDerivation rec {
  version = "0.8.6";
  pname = "ocaml${ocaml.version}-ptime";

  minimalOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://erratique.ch/software/ptime/releases/ptime-${version}.tbz";
    sha256 = "sha256-gy/fUsfUHUZx1A/2sQMQIFMHl1V+QO3zHAsEnZT/lkI=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ] ++ lib.optional jsooSupport js_of_ocaml;

  strictDeps = true;

  buildPhase = "${topkg.run} build --with-js_of_ocaml ${lib.boolToString jsooSupport}";

  inherit (topkg) installPhase;

  meta = {
    homepage = "https://erratique.ch/software/ptime";
    description = "POSIX time for OCaml";
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
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
