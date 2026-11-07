{
  buildDunePackage,
  raven,
  raven-nx,
  windtrap,
  mdx,
  logs,
}:

buildDunePackage {
  pname = "talon";

  inherit (raven) version src postUnpack;

  propagatedBuildInputs = [
    raven-nx
  ];

  doCheck = true;

  nativeCheckInputs = [
    mdx.bin
    (mdx.override { inherit logs; })
  ];

  checkInputs = [
    windtrap
    mdx
  ];

  meta = raven.meta // {
    description = "A dataframe library for OCaml";
    longDescription = ''
      Talon provides efficient tabular data manipulation with
      heterogeneous column types, inspired by pandas and polars.
    '';
  };
}
