{
  buildDunePackage,
  fetchurl,
  lib,
  zarith,
  digestif,
  fmt,
}:

buildDunePackage rec {
  pname = "tezos-base58";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/tarides/tezos-base58/releases/download/${version}/${pname}-${version}.tbz";
    hash = "sha256-qpnhwl4zlMyLAdrrpUNp83Y0hVP9IlS+7dX4Vpy7gpM=";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [
    zarith
    digestif
    fmt
  ];

  meta = {
    description = "Base58 encoding for Tezos";
    homepage = "https://github.com/tarides/tezos-base58/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bezmuth ];
  };

}
