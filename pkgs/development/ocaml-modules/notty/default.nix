{ stdenv, buildOcaml, fetchFromGitHub, findlib
, result, uucp, uuseg, uutf
, lwt     ? null }:

with stdenv.lib;

let withLwt = lwt != null; in

buildOcaml rec {
  version = "0.1.1";
  name = "notty";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner  = "pqwy";
    repo   = "notty";
    rev    = "v${version}";
    sha256 = "0bw3bq8z2y1rhc20zn13s78sazywyzpg8nmyjch33p7ypxfglf01";
  };

  buildInputs = [ findlib ];
  propagatedBuildInputs = [ result uucp uuseg uutf ] ++
                          optional withLwt [ lwt ];

  configureFlags = [ "--enable-unix" ] ++
                   (if withLwt then ["--enable-lwt"] else ["--disable-lwt"]);

  configurePhase = "./configure --prefix $out $configureFlags";

  meta = {
    inherit (src.meta) homepage;
    description = "Declarative terminal graphics for OCaml";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
