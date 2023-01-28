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
  version = "0.5.13";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ssl";
    rev = version;
    sha256 = "sha256-Ws7QZOvZVy0QixMiBFJZEOnYzYlCWrZ1d95gOp/a5a0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ openssl ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  nativeCheckInputs = [ alcotest ];
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
