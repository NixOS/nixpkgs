{
  buildDunePackage,
  fetchpatch2,
  caqti,
  logs,
  eio,
}:

buildDunePackage {
  pname = "caqti-eio";
  inherit (caqti) version src;

  minimalOCamlVersion = "5.1";

  patches = [
    # Remove once https://github.com/paurkedal/ocaml-caqti/pull/151 is merged
    (fetchpatch2 {
      name = "caqti-eio-1.7-compat.patch";
      url = "https://github.com/paurkedal/ocaml-caqti/commit/50ba7c794b211c2bfdeae31c4c0aa00a19759fc9.patch?full_index=1";
      hash = "sha256-nq15lCmifDC3k9Gm+A0QheG4uu2P+wNdLrJNz6Y5KG0=";
    })
  ];

  propagatedBuildInputs = [
    caqti
    logs
    eio
  ];

  meta = caqti.meta // {
    description = "Eio support for Caqti";
  };
}
