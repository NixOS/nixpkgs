{
  buildDunePackage,
  letsencrypt,
  emile,
  http-mirage-client,
  paf,
}:

buildDunePackage {
  pname = "letsencrypt-mirage";

  inherit (letsencrypt) version src;

  propagatedBuildInputs = [
    emile
    http-mirage-client
    letsencrypt
    paf
  ];

  meta = letsencrypt.meta // {
    description = "ACME implementation in OCaml for MirageOS";
  };
}
