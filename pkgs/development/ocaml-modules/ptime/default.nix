{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, result, js_of_ocaml }:

stdenv.mkDerivation rec {
  version = "0.8.4";
  name = "ocaml${ocaml.version}-ptime-${version}";

  src = fetchurl {
    url = "https://erratique.ch/software/ptime/releases/ptime-${version}.tbz";
    sha256 = "0z2snhda8bg136xkw2msw6k2dz84vb49p8bgzrxfs8mawdlk0kkg";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg js_of_ocaml ];

  propagatedBuildInputs = [ result ];

  buildPhase = "${topkg.run} build --with-js_of_ocaml true";

  inherit (topkg) installPhase;

  meta = {
    homepage = https://erratique.ch/software/ptime;
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
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ sternenseemann ];
  };
}
