{
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
  mirage-crypto-rng,
  mirage-ptime,
  ptime,
  multipart_form-lwt,
  ssl,
  unstrctrd,
  uri,
  yojson,
}:

buildDunePackage {
  pname = "dream";

  inherit (dream-pure) version src;

  buildInputs = [ lwt_ppx ];

  propagatedBuildInputs = [
    caqti-lwt
    camlp-streams
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
    mirage-crypto-rng
    mirage-ptime
    multipart_form-lwt
    ptime
    yojson
    ssl
    unstrctrd
    uri
  ];

  meta = dream-pure.meta // {
    description = "Tidy, feature-complete Web framework";
  };
}
