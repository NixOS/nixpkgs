{
  lib,
  buildDunePackage,
  dream-pure,
  lwt_ppx,
  camlp-streams,
  caqti-lwt,
  cstruct,
  digestif,
  dream-httpaf,
  graphql-lwt,
  h2-lwt-unix,
  httpun-lwt-unix,
  httpun-ws,
  lambdasoup,
  lwt_ssl,
  magic-mime,
  markup,
  mirage-clock,
  mirage-crypto-rng,
  mirage-crypto-rng-lwt,
  multipart_form-lwt,
  ssl,
  unstrctrd,
  uri,
  yojson,
}:

buildDunePackage {
  pname = "dream";

  inherit (dream-pure) version src;

  # Compatibility with httpun 0.2.0 and h2 0.13
  patches = [ ./httpun.patch ];

  buildInputs = [ lwt_ppx ];

  propagatedBuildInputs = [
    camlp-streams
    caqti-lwt
    cstruct
    digestif
    dream-httpaf
    dream-pure
    graphql-lwt
    h2-lwt-unix
    httpun-lwt-unix
    httpun-ws
    lambdasoup
    lwt_ssl
    magic-mime
    markup
    mirage-clock
    mirage-crypto-rng
    mirage-crypto-rng-lwt
    multipart_form-lwt
    ssl
    unstrctrd
    uri
    yojson
  ];

  meta = dream-pure.meta // {
    description = "Tidy, feature-complete Web framework";
  };
}
