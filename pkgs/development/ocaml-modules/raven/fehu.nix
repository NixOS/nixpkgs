{
  buildDunePackage,
  alcotest,
  raven,
  raven-kaun,
  raven-rune,
  yojson,
}:

buildDunePackage {
  pname = "fehu";

  inherit (raven) version src postUnpack;

  propagatedBuildInputs = [
    raven-kaun
    raven-rune
    yojson
  ];

  doCheck = true;

  checkInputs = [
    alcotest
  ];

  meta = raven.meta // {
    description = "Reinforcement learning framework for OCaml";
    longDescription = ''
      Fehu is a reinforcement learning framework built on Raven's ecosystem,
      providing environments, algorithms, and training utilities
    '';
  };
}
