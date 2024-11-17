{ lib, stdenv, buildDunePackage, mirage-crypto, ohex, ounit2, randomconv
, dune-configurator, digestif, duration, logs }:

buildDunePackage rec {
  pname = "mirage-crypto-rng";

  inherit (mirage-crypto) version src;

  # https://github.com/mirage/mirage-crypto/issues/216
  # aarch64 counter may run at 24MHz causing test to fail
  postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    substituteInPlace tests/test_entropy.ml \
      --replace-fail \
        'failwith ("same data from timer at "' \
        'print_endline ("WARNING: same data from timer at "'
  '';

  doCheck = true;
  checkInputs = [ ohex ounit2 randomconv ];

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ digestif mirage-crypto duration logs ];

  meta = mirage-crypto.meta // {
    description = "Cryptographically secure PRNG";
  };
}
