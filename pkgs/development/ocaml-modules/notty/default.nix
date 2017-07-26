{ stdenv, buildOcaml, fetchpatch, fetchFromGitHub, findlib, topkg, opam, ocb-stubblr
, result, uucp, uuseg, uutf
, lwt     ? null }:

with stdenv.lib;

let withLwt = lwt != null; in

buildOcaml rec {
  version = "0.1.1a";
  name = "notty";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner  = "pqwy";
    repo   = "notty";
    rev    = "53f5946653490fce980dc5d8cadf8b122cff4f19";
    sha256 = "0qmwb1hrp04py2i5spy0yd6c5jqxyss3wzvlkgxyl9r07kvsx6xf";
  };

  patches = [ (fetchpatch {
    url = https://github.com/dbuenzli/notty/commit/b0e12930acc26d030a74d6d63d622ae220b12c92.patch;
    sha256 = "0pklplbnjbsjriqj73pc8fsadg404px534w7zknz2617zb44m6x6";
  })];

  buildInputs = [ findlib opam topkg ocb-stubblr ];
  propagatedBuildInputs = [ result uucp uuseg uutf ] ++
                          optional withLwt lwt;

  buildPhase = topkg.buildPhase
  + " --with-lwt ${boolToString withLwt}";

  inherit (topkg) installPhase;

  meta = {
    inherit (src.meta) homepage;
    description = "Declarative terminal graphics for OCaml";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
