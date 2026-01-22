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
  mirage-clock,
  mirage-crypto-rng,
  multipart_form-lwt,
  ssl,
  unstrctrd,
  uri,
  yojson,
  # for mirage-crypro-rng-lwt 1.2.0
  # It is removed from mirage-crypto 2.1.0 now.
  fetchurl,
  duration,
  logs,
  mtime,
  lwt,
}:

let
  mirage-crypto-rng-lwt = buildDunePackage rec {
    pname = "mirage-crypto-rng-lwt";
    version = "1.2.0";
    src = fetchurl {
      url = "https://github.com/mirage/mirage-crypto/releases/download/v${version}/mirage-crypto-${version}.tbz";
      hash = "sha256-CVQrzZbB02j/m6iFMQX0wXgdjJTCQA3586wGEO4H5n4=";
    };
    doCheck = true;
    propagatedBuildInputs = [
      mirage-crypto-rng
      duration
      logs
      mtime
      lwt
    ];
  };
in

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
