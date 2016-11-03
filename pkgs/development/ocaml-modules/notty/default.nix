{ stdenv, buildOcaml, fetchFromGitHub, findlib
, result, uucp, uuseg, uutf
, withLwt ? true
, lwt     ? null }:

with stdenv.lib;
assert withLwt -> lwt != null;

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
                          optional withLwt lwt;

  configureFlags = [ "--enable-unix" ] ++
                   optional withLwt ["--enable-lwt"];
  configurePhase = "./configure --prefix $out $configureFlags";

  meta = with stdenv.lib; {
    homepage = https://github.com/pqwy/notty/tree/master;
    description = "Declarative terminal graphics for OCaml.";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
