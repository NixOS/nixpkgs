{
  fetchurl,
  buildDunePackage,
  testo,
  ppx_deriving,
}:

buildDunePackage {
  pname = "testo-diff";
  inherit (testo) version src;

  propagatedBuildInputs = [ ppx_deriving ];

  meta = testo.meta // {
    description = "Pure-OCaml diff implementation";
  };
}
