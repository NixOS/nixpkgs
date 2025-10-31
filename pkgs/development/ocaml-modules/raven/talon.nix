{
  buildDunePackage,
  alcotest,
  csv,
  raven,
  raven-nx,
  re,
  yojson,
}:

buildDunePackage {
  pname = "talon";

  inherit (raven) version src postUnpack;

  propagatedBuildInputs = [
    csv
    raven-nx
    re
    yojson
  ];

  doCheck = true;

  checkInputs = [
    alcotest
  ];

  meta = raven.meta // {
    description = "A dataframe library for OCaml";
    longDescription = ''
      Talon provides efficient tabular data manipulation with
      heterogeneous column types, inspired by pandas and polars.
    '';
  };
}
