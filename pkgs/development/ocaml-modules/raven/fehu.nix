{
  buildDunePackage,
  windtrap,
  raven,
  raven-nx,
  mdx,
  logs,
}:

buildDunePackage {
  pname = "fehu";

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
    description = "Reinforcement learning framework for OCaml";
    longDescription = ''
      Fehu is a reinforcement learning framework built on Raven's ecosystem,
      providing environments, algorithms, and training utilities
    '';
  };
}
