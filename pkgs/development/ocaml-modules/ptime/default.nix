{ stdenv, fetchurl, buildOcaml, ocaml, findlib, ocamlbuild, topkg, result, opam, js_of_ocaml }:

buildOcaml rec {
  version = "0.8.3";
  name = "ptime";

  src = fetchurl {
    url = "http://erratique.ch/software/ptime/releases/ptime-${version}.tbz";
    sha256 = "18jimskgnd9izg7kn6zk6sk35adgjm605dkv13plwslbb90kqr44";
  };

  unpackCmd = "tar -xf $curSrc";

  buildInputs = [ ocaml findlib ocamlbuild topkg opam js_of_ocaml ];

  propagatedBuildInputs = [ result ];

  buildPhase = ''
    ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/ pkg/pkg.ml build --with-js_of_ocaml true
  '';

  inherit (topkg) installPhase;

  meta = {
    homepage = http://erratique.ch/software/ptime;
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
