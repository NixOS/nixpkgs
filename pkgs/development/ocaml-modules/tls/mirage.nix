{ buildDunePackage, tls
, fmt, lwt, mirage-clock, mirage-crypto, mirage-crypto-ec, mirage-crypto-pk, mirage-flow, mirage-kv, ptime, x509
}:

buildDunePackage {
  pname = "tls-mirage";
  inherit (tls) src version;
<<<<<<< HEAD
=======
  duneVersion = "3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = [
    fmt
    lwt
    mirage-clock
    mirage-crypto
    mirage-crypto-ec
    mirage-crypto-pk
    mirage-flow
    mirage-kv
    ptime
    tls
    x509
  ];

  meta = tls.meta // {
    description = "Transport Layer Security purely in OCaml, MirageOS layer";
  };
}
