{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg, result, js_of_ocaml
, jsooSupport ? true
}:

stdenv.mkDerivation rec {
  version = "0.8.5";
  pname = "ocaml${ocaml.version}-ptime";

  src = fetchurl {
    url = "https://erratique.ch/software/ptime/releases/ptime-${version}.tbz";
    sha256 = "1fxq57xy1ajzfdnvv5zfm7ap2nf49znw5f9gbi4kb9vds942ij27";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ] ++ lib.optional jsooSupport js_of_ocaml;

  strictDeps = true;

  propagatedBuildInputs = [ result ];

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
