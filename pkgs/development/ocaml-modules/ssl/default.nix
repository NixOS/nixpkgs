{ alcotest
, buildDunePackage
, dune-configurator
, fetchFromGitHub
, lib
, ocaml
, openssl
, pkg-config
}:

buildDunePackage rec {
  pname = "ssl";
  version = "0.6.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ssl";
    rev = version;
    sha256 = "sha256-zi5Ue6qOlLfsfPjzIwjjR+6ztSS2NwJmB1cCcVVC5TY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ openssl ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ alcotest ];
  preCheck = ''
    mkdir -p _build/default/tests/
    cp tests/digicert_certificate.pem _build/default/tests/
  '';

  meta = {
    homepage = "http://savonet.rastageeks.org/";
    description = "OCaml bindings for libssl ";
    license = "LGPL+link exception";
    maintainers = with lib.maintainers; [ anmonteiro dandellion maggesi ];
  };
}
