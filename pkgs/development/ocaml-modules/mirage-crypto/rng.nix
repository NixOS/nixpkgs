{
  lib,
  stdenv,
  buildDunePackage,
  mirage-crypto,
  ohex,
  ounit2,
  randomconv,
  dune-configurator,
  digestif,
  duration,
  logs,
}:

buildDunePackage {
  pname = "mirage-crypto-rng";

  minimalOCamlVersion = "4.14";

  inherit (mirage-crypto) version src;

  doCheck = true;
  checkInputs = [
    ohex
    ounit2
    randomconv
  ];

  # test_entropy relies on timer jitter and is flaky on x86_64-darwin.
  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    substituteInPlace tests/dune \
      --replace-fail \
        '(enabled_if (and (<> %{architecture} "arm64") (<> %{architecture} "riscv")))' \
        '(enabled_if false)'
  '';

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    digestif
    mirage-crypto
    duration
    logs
  ];

  meta = mirage-crypto.meta // {
    description = "Cryptographically secure PRNG";
  };
}
