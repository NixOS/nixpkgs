{ lib, fetchurl, buildDunePackage
, cstruct, sexplib0, rresult, mirage-crypto, mirage-crypto-pk, astring, base64
, mirage-crypto-rng
}:

buildDunePackage rec {
  pname = "otr";
  version = "0.3.8";

  src = fetchurl {
    url = "https://github.com/hannesm/ocaml-otr/releases/download/v${version}/otr-v${version}.tbz";
    sha256 = "18hn9l8wznqnlh2jf1hpnp36f1cx80ncwiiivsbj34llhgp3893d";
  };

  useDune2 = true;

  propagatedBuildInputs = [ cstruct sexplib0 mirage-crypto mirage-crypto-pk
                            astring rresult base64 ];

  doCheck = true;
  checkInputs = [ mirage-crypto-rng ];

  meta = with lib; {
    homepage = "https://github.com/hannesm/ocaml-otr";
    description = "Off-the-record messaging protocol, purely in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
