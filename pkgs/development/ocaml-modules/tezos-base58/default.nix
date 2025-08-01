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
    sha256 = "14w2pff5dy6mxnz588pxaf2k8xpkd51sbsys065wr51kbv1f36da";
  };

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  propagatedBuildInputs = [
    zarith
    digestif
    fmt
  ];

  meta = with lib; {
    description = "Base58 encoding for Tezos";
    homepage = "https://github.com/tarides/tezos-base58/";
    license = licenses.mit;
    maintainers = with maintainers; [ bezmuth ];
  };

}
